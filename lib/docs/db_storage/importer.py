#!/usr/bin/python
# -*- coding: utf-8 -*-
import json
import psycopg2
import sys
import ConfigParser
import os.path
import re
import time
import logging

from lxml import html

class DocImporter():
    connection_string = ''
    content_path = ''
    debugMode = False
    linkerrors = []
    docset = ''
    filename = ''
    docset_name = ''
    index_path = ''
    default_uri = ''
    total_entries = 0
    links = {}
    link_re = re.compile('<a[\w _\-="]*href="(?!\w*:\/\/)([\(\)\*:$\_~\+\(\)\!\#\/%\-\w\.]*)"', re.IGNORECASE)

    #load config file
    def __init__(self, docset):
        self.config = ConfigParser.ConfigParser()
        self.config.read('importer.cfg')
        User = self.config.get('Connection', 'User', 0)
        Password = self.config.get('Connection', 'Password', 0)
        Host = self.config.get('Connection', 'Host', 0)
        DBname = self.config.get('Connection', 'DBname', 0)
        self.connection_string = "host='"+ Host + "' dbname='" + DBname + "' user='" + User + "' password='" + Password + "'"
        self.debugMode = bool(self.config.get('Config', 'debugMode', 0))
        self.content_path = self.config.get('Path', 'base_path', 0)
        if docset == 'all':
            sections = self.config.sections()
            for sect in sections:
                if sect not in ['Connection', 'Config', 'Path']:
                    self.docset = sect
                    self.docset_name = self.config.get(sect, 'name', 0)
                    self.default_uri = self.config.get(sect, 'default_uri', 0)
                    self.index_path = self.content_path + sect +  '/index.json'
                    print '########################################   ' + sect + '   ########################################'
                    self.importToDB()
        else:
            self.docset = docset
            self.docset_name = self.config.get(self.docset, 'name', 0)
            self.default_uri = self.config.get(self.docset, 'default_uri', 0)
            self.index_path = self.content_path + self.docset +  '/index.json'


    def ProcessContent(self, content):
        for match in re.findall(self.link_re,content):
            anchor = ''
            keymatch = match.lower().replace('../', '') #.replace('%24', '$')
            if match.find('#')!=-1 and keymatch not in self.links.keys():
                anchor = keymatch[keymatch.find('#'):]
                keymatch = keymatch[:keymatch.find('#')]
            if keymatch in self.links.keys():
                #print '"' + keymatch + '" - "' + match + '" : "' + self.links[keymatch] + '"'
                content = content.replace('"' + match + '"', '"' + self.links[keymatch] + anchor + '"',1)
            if keymatch not in self.links and anchor == '' and keymatch != '/help':
                hour = time.strftime("%d/%m/%Y %H:%M:%S")
                self.linkerrors.append('- "' + keymatch + '" in ' + self.filename)
        return content

    def importToDB(self):
        conn = psycopg2.connect(self.connection_string)
        try:
            json_data = self.processJSON(self.index_path)
            self.links = self.CreateLinkCollection(json_data)
            self.initTable(conn)
            self.emptyTable(conn,self.docset_name)
            previous_uri = ''
            procesed_entries = {}
            total = len(json_data)
            i = 1
            for entry in json_data:
                _name = entry['name']
                if self.debugMode:
                    print ('Process: ' + entry['path']).ljust(50) + ('[' + str(i)+ '/' + str(total) + ']').rjust(30)
                    i+=1
                if entry['path'].find('#')!= -1:
                     entry['path'] = entry['path'].split('#')[0]
                filename = self.getFileName(self.content_path,self.docset, entry['path'])
                #Avoid Process the same Page twice
                if entry['path'] in procesed_entries.keys():
                    _content = procesed_entries[entry['path']]
                else:
                    self.filename = filename
                    _content = self.ProcessContent(self.getContent(filename))
                    procesed_entries[entry['path']] = _content

                if entry['parent_uri'] == 'null':
                    _parent_uri = None
                else:
                    _parent_uri = entry['parent_uri']
                _type = entry['type']
                _docset = entry['docset']
                _uri = entry['parsed_uri']
                _anchor = entry['anchor']
                if previous_uri != _uri:
                    self.insertRow(conn, _name, _content, _parent_uri, _type, _docset, _uri,_anchor)
                    previous_uri = _uri
        
            self.moveToData(conn)
            self.updateDocsets(conn,self.docset_name, self.default_uri)
            self.Commit(conn)
        except Exception, e:
            hour = time.strftime("%d/%m/%Y %H:%M:%S")
            self.ferrors = open('errors_' + hour.replace('/','_').replace(' ','_').replace(':','-') + '.log', 'a')
            self.ferrors.write('\n\n\n########################################   ' + self.docset_name + '   ########################################\n\n\n')
            self.Rollback(conn)
            self.initTable(conn)
            self.linkerrors = []
            self.ferrors.write('- ' + hour + ' error in ' + self.docset_name + ':  %s\n' % e)
            self.ferrors.close()
            print '========= ERROR ============='
            print e
        if len(self.linkerrors)>0:
            brokenlinksfile = open('brokenlinks_' + self.docset_name +'.log', 'a')
            hour = time.strftime("%d/%m/%Y %H:%M:%S")
            brokenlinksfile.write('\n\n\n########################################   ' + hour + '   -   ' + self.docset_name + '   ########################################\n\n\n')
            for error in self.linkerrors:
                brokenlinksfile.write(error + '\n')
            self.linkerrors = []
            brokenlinksfile.close()
        self.Finish(conn)

    def CreateLinkCollection(self, entries):
        links = {}
        for entry in entries:
            if entry['path'].lower() not in links.keys() or entry['anchor']=='':
                links[entry['path'].lower()] = entry['parsed_uri']
            if entry['anchor']!= '':
                links[entry['path'][entry['path'].find('/'):].lower()] = entry['parsed_uri']
                links[(entry['path'] + '#' + entry['anchor']).lower()] = entry['parsed_uri']
                links['#' + entry['anchor'].lower()] = entry['parsed_uri']
            # EXCEPTION FOR Haskell
            if entry['docset'].lower() == 'haskell':
               links[entry['path'][entry['path'].find('/')+1:].lower()] = entry['parsed_uri']
            # EXCEPTION FOR Python
            if entry['docset'].lower() == 'python3' or entry['docset'].lower() == 'python2':
               links[entry['path'][entry['path'].find('/')+1:].lower() + '.html'] = entry['parsed_uri']
               links[entry['path'] + '.html'] = entry['parsed_uri']
            # EXCEPTION FOR C++
            if entry['docset'].lower() == 'cpp' or entry['docset'].lower() == 'c':
                links[entry['path'][entry['path'].find('/')+1:].lower()] = entry['parsed_uri']
                links[entry['path'].replace('fs/', '').replace('io/', '').replace('experimental/', '')] = entry['parsed_uri']
                links[entry['path'].split('/')[-1]] = entry['parsed_uri']
        return links

    def getFileName(self, content_path, docset, path):
        if not path.endswith('.html'):
            path += '.html'
        filename = content_path + docset + '/' + path
        return filename

    def getContent(self, filename):
        with open(filename, 'r') as content_file:
            content = content_file.read().decode('utf-8')
        return content

    def processJSON(self,file_path):
        if os.path.isfile(file_path):
            with open(file_path) as json_file:
                json_data = json.load(json_file)
            self.total_entries = len(json_data['entries'])
            return json_data['entries']
        else:
            raise Exception("'index.json not found in docset " + self.docset_name)

    def Connect():
        return psycopg2.connect(self.connection_string)

    def Commit(self, conn):
        conn.commit()
        print self.docset_name + ' import succeed! \n ' + str(self.total_entries) + ' imported'

    def Rollback(self, conn):
        conn.rollback()

    def insertRow(self, conn, _name, _content, _parent, _type, _docset, _uri, _anchor):
        pgcursor = conn.cursor()
        sqlinsertitem = "INSERT INTO temp_refs (reference, content, parent, type, docset, uri, content_anchor) VALUES (%s, %s, %s, %s, %s, %s, %s);"
        pgcursor.execute(sqlinsertitem,[_name,
                                        _content,
                                        _parent,
                                        _type,
                                        _docset,
                                        _uri,
                                        _anchor])


    def moveToData(self, conn):
        sqlmovedata = 'INSERT INTO refs (reference, content,uri,content_anchor,parent_uri,type,docset) SELECT reference,content,uri,content_anchor,parent,type, docset FROM temp_refs;'
        pgcursor = conn.cursor()
        pgcursor.execute(sqlmovedata)


    def emptyTable(self, conn, docset):
        sqlemptytables = 'DELETE FROM refs WHERE docset=%s;'
        pgcursor = conn.cursor()
        pgcursor.execute(sqlemptytables, [docset])
        conn.commit()

    def initTable(self, conn):
        sqlinittable = 'TRUNCATE TABLE temp_refs;'
        pgcursor = conn.cursor()
        pgcursor.execute(sqlinittable)
        conn.commit()

    def updateDocsets(self, conn, docset, default_uri):
        sqldocsetselect = "SELECT docset FROM docsets WHERE docset = %s;"
        sqldocsetinsert = "INSERT INTO docsets (docset, default_uri, pub_date, update_date, active) VALUES (%s,%s,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,%s);"
        sqldocsetupdate = "UPDATE docsets SET default_uri = %s, update_date = CURRENT_TIMESTAMP WHERE docset = %s"
        pgcursor = conn.cursor()
        pgcursor.execute(sqldocsetselect, [docset])
        docsetsrow = pgcursor.fetchone()
        if docsetsrow:
            pgcursor.execute(sqldocsetupdate, [default_uri, docset])
        else:
            pgcursor.execute(sqldocsetinsert,[docset, default_uri, True])

    def Finish(self,conn):
        self.initTable(conn)
        conn.close()

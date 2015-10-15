#!/usr/bin/python
# -*- coding: utf-8 -*-
import json
import psycopg2
import sys
import ConfigParser
import os.path
import re
import time
import math
import logging

from lxml import html

class DocImporter():
    connection_string = ''
    content_path = ''
    debugMode = False
    linkerrors = []
    additional = False
    docset = ''
    filename = ''
    docset_name = ''
    docset_parsed_name = ''
    index_path = ''
    default_uri = ''
    total_entries = 0
    links = {}

    #load config file
    def __init__(self, _docset, _mode, _connectionstring):
        self.config = ConfigParser.ConfigParser()
        self.config.read('importer.cfg')
        if(_connectionstring==''):
            User = self.config.get('Connection', 'User', 0)
            Password = self.config.get('Connection', 'Password', 0)
            Host = self.config.get('Connection', 'Host', 0)
            DBname = self.config.get('Connection', 'DBname', 0)
            self.connection_string = "host='"+ Host + "' dbname='" + DBname + "' user='" + User + "' password='" + Password + "'"
        else:
            self.connection_string = _connectionstring
        self.debugMode = bool(self.config.get('Config', 'debugMode', 0))
        self.content_path = self.config.get('Path', 'base_path', 0)
        sections = self.config.sections()
        if _mode == 'continue':
            sections = sections[sections.index(_docset):]
        elif _mode == 'single':
            sections = [_docset]
        conn = psycopg2.connect(self.connection_string)
        self.processDocsets(sections)


    def processDocsets(self, docsetlist):
        for sect in docsetlist:
            if sect not in ['Connection', 'Config', 'Path']:
                if self.config.get(sect, 'active', 0) == 'true':
                    try:
                        self.docset = sect
                        self.docset_name = self.config.get(sect, 'name', 0)
                        self.docset_parsed_name = self.config.get(sect, 'parsed_name', 0)
                        self.default_uri = self.config.get(sect, 'default_uri', 0)
                        self.additional =  self.config.get(sect, 'additional', 0)
                        self.index_path = self.content_path + sect +  '/index.json'
                        print "\rImporting " + sect + "..."
                        self.importToDB()
                    except:
                        lastimportfile = open('lastimport.log', 'w')
                        lastimportfile.truncate()
                        lastimportfile.write(sect)
                        lastimportfile.close();



    def processContent(self, content):
        tree = html.fromstring(content)
        links = tree.xpath('//a[@href]')
        for alink in links:
            anchor = ''
            keymatch = ''
            if alink.get('href')!=None:
                match = alink.get('href')
                keymatch = match.lower().replace('../', '').replace('%24', '$')
            else:
                match = '#'
                keymatch = '#'
            if not keymatch.startswith('http://') and not keymatch.startswith('https://') and not keymatch.startswith('ftp://') and not keymatch.startswith('irc://') and not keymatch.startswith('news://') and not keymatch.startswith('mailto:') and keymatch!= '':
                if match.find('#')!=-1 and keymatch not in self.links.keys():
                    anchor = keymatch[keymatch.find('#'):]
                    keymatch = keymatch[:keymatch.find('#')]
                if keymatch in self.links.keys():
                    #print '"' + keymatch + '" - "' + match + '" : "' + self.links[keymatch] + '"'
                    content = content.replace('"' + match + '"', '"' + self.links[keymatch] + anchor + '"',1)
                if keymatch not in self.links and anchor == '' and alink.get('class') != 'broken':
                    hour = time.strftime("%d/%m/%Y %H:%M:%S")
                    self.linkerrors.append('- "' + keymatch + '" in ' + self.filename)
        return content

    def importToDB(self):
        conn = psycopg2.connect(self.connection_string)
        try:
            json_data = self.processJSON(self.index_path)
            self.links = self.createLinkCollection(json_data)
            self.initTable(conn)
            previous_uri = ''
            procesed_entries = {}
            total = len(json_data)
            i = 1
            for entry in json_data:
                _name = entry['name']
                loading_value = int(math.ceil(float(50)/total*i))
                gap_value = 50 - loading_value
                loading_bar = ("#" * loading_value) + (" " * gap_value)
                sys.stdout.write('\r[' + loading_bar + '](' + str(i)+ '/' + str(total) + ')')
                sys.stdout.flush()                    
                i+=1
                if entry['path'].find('#')!= -1:
                     entry['path'] = entry['path'].split('#')[0]
                filename = self.getFileName(self.content_path,self.docset, entry['path'])
                #Avoid Process the same Page twice
                if entry['path'] in procesed_entries.keys():
                    _content = procesed_entries[entry['path']]
                else:
                    self.filename = filename
                    _content = self.processContent(self.getContent(filename))
                    procesed_entries[entry['path']] = _content

                if entry['parent_uri'] == 'null':
                    _parent_uri = None
                else:
                    _parent_uri = entry['parent_uri']
                _type = entry['type']
                _docset = entry['docset']
                _uri = entry['parsed_uri']
                _anchor = entry['anchor']
                _source_url = entry['source_url']
                if previous_uri != _uri:
                    self.insertRow(conn, _name, _content, _parent_uri, _type, _docset, _uri, _anchor, _source_url)
                    previous_uri = _uri
            if self.additional == 'false':
              self.emptyTable(conn,self.docset_name)
            self.moveToData(conn)
            self.updateDocsets(conn,self.docset_name, self.default_uri, self.docset_parsed_name)
            self.commit(conn)
        except Exception, e:
            hour = time.strftime("%d/%m/%Y %H:%M:%S")
            self.ferrors = open('import_errors.log', 'a')
            self.ferrors.write('\n\n\n########################################   ' + self.docset_name + '   ########################################\n\n\n')
            self.rollback(conn)
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
        self.finish(conn)

    def createLinkCollection(self, entries):
        links = {}
        for entry in entries:
            if entry['path'].lower() not in links.keys() or entry['anchor']=='':
                links[entry['path'].lower()] = entry['parsed_uri']
            if entry['anchor']!= '':
                links[entry['path'][entry['path'].find('/'):].lower()] = entry['parsed_uri']
                links[(entry['path'] + '#' + entry['anchor']).lower()] = entry['parsed_uri']
                links['#' + entry['anchor'].lower()] = entry['parsed_uri']
            # EXCEPTION FOR C++ this because the limitations of the documentation into the zip
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

    def connect():
        return psycopg2.connect(self.connection_string)

    def commit(self, conn):
        conn.commit()
        print '\n' + self.docset_name + ' imports ' + str(self.total_entries) + '\n'

    def rollback(self, conn):
        conn.rollback()

    def insertRow(self, conn, _name, _content, _parent, _type, _docset, _uri, _anchor, _source_url):
        pgcursor = conn.cursor()
        sqlinsertitem = "INSERT INTO temp_refs (reference, source_url, parent, type, docset, uri, content_anchor) VALUES (%s, %s, %s, %s, %s, %s, %s);"
        pgcursor.execute(sqlinsertitem,[_name,
                                        _source_url,
                                        _parent,
                                        _type,
                                        _docset,
                                        _uri,
                                        _anchor])

        self.removedContent(conn, _source_url)
        self.insertContent(conn, _content, _source_url)

    def insertContent(self, conn, _content, _source_url):
        pgcursor = conn.cursor()
        sqlinsertcontent = "INSERT INTO refs_content (source_url, content) VALUES(%s, %s);"

        pgcursor.execute(sqlinsertcontent,[_source_url,
                                        _content])

    def moveToData(self, conn):
        sqlmovedata = 'INSERT INTO refs (reference, source_url, uri, content_anchor, parent_uri, type, docset) SELECT reference, source_url,uri,content_anchor,parent,type, docset FROM temp_refs;'
        pgcursor = conn.cursor()
        pgcursor.execute(sqlmovedata)


    def emptyTable(self, conn, docset):
        sqlemptytables = 'DELETE FROM refs WHERE docset=%s;'
        pgcursor = conn.cursor()
        pgcursor.execute(sqlemptytables, [docset])
        conn.commit()

    def removedContent(self, conn, _source_url):
        sqlemptycontent = 'DELETE FROM refs_content WHERE source_url=%s;'
        pgcursor = conn.cursor()
        pgcursor.execute(sqlemptycontent, [_source_url])
        conn.commit()

    def initTable(self, conn):
        sqlinittable = 'TRUNCATE TABLE temp_refs;'
        pgcursor = conn.cursor()
        pgcursor.execute(sqlinittable)
        conn.commit()

    def updateDocsets(self, conn, docset, default_uri, parsed_name):
        sqldocsetselect = "SELECT docset FROM docsets WHERE docset = %s;"
        sqldocsetinsert = "INSERT INTO docsets (docset, default_uri, pub_date, update_date, active, parsed_name) VALUES (%s,%s,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,%s,%s);"
        sqldocsetupdate = "UPDATE docsets SET default_uri = %s, update_date = CURRENT_TIMESTAMP, parsed_name = %s WHERE docset = %s"
        pgcursor = conn.cursor()
        pgcursor.execute(sqldocsetselect, [docset])
        docsetsrow = pgcursor.fetchone()
        if docsetsrow:
            pgcursor.execute(sqldocsetupdate, [default_uri, docset, parsed_name])
        else:
            pgcursor.execute(sqldocsetinsert,[docset, default_uri, True, parsed_name])

    def finish(self,conn):
        self.initTable(conn)
        conn.close()

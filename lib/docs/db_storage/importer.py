#!/usr/bin/python
import json
import psycopg2
import sys
import ConfigParser
import os.path

from lxml import html

class DocImporter():
    connection_string = ''
    content_path = ''
    debugMode = False
    docset = ''
    docset_name = ''
    index_path = ''
    default_uri = ''
    total_entries = 0

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
                    print '######################' + sect + '######################'
                    self.importToDB()
        else:
            self.docset = docset
            self.docset_name = self.config.get(self.docset, 'name', 0)
            self.default_uri = self.config.get(self.docset, 'default_uri', 0)
            self.index_path = self.content_path + self.docset +  '/index.json'

    def ProcessContent(self, json_data, content):
        for entry in json_data:
            path = entry['path']
            parsed_uri = entry['parsed_uri']
            content = content.replace(u'"' + path +'"', u'"' + parsed_uri + '"')
        return content

    def importToDB(self):
        json_data = self.processJSON(self.index_path)
        conn = psycopg2.connect(self.connection_string)
        self.initTable(conn)
        self.emptyTable(conn,self.docset_name)
        previous_uri = ''
        total = len(json_data)
        i = 0
        for entry in json_data:
            _name = entry['name']
            if self.debugMode:
                print ('Process: ' + entry['path']).ljust(50) + ('[' + str(i)+ '/' + str(total) + ']').rjust(30)
                i+=1
            if entry['path'].find('#')!= -1:
                 entry['path'] = entry['path'].split('#')[0]
            _content = self.ProcessContent(json_data, self.getContent(self.content_path + self.docset + '/' + entry['path'] + '.html'))
            if entry['parent_uri'] == 'null':
                _parent_uri = None
            else:
                _parent_uri = entry['parent_uri']
            _type = entry['type']
            _docset = entry['docset']
            _uri = entry['parsed_uri']
            if previous_uri != _uri:
                self.insertRow(conn, _name, _content, _parent_uri, _type, _docset, _uri)
                previous_uri = _uri
        #self.Commit(conn)
        self.moveToData(conn)
        self.updateDocsets(conn,self.docset_name, self.default_uri)
        self.Commit(conn)
        self.Finish(conn)


    def getContent(self, path):
        # case for PHP in tidy.html.html
        if path.find('.html.html')!=-1:
            path = path.replace('.html.html', '.html')
        with open(path, 'r') as content_file:
            content = content_file.read().decode('utf-8')
        return content



    def processJSON(self,file_path):
        with open(file_path) as json_file:
            json_data = json.load(json_file)
        self.total_entries = len(json_data['entries'])
        return json_data['entries']

    def Connect():
        return psycopg2.connect(self.connection_string)

    def Commit(self, conn):
        conn.commit()

    def insertRow(self, conn, _name, _content, _parent, _type, _docset, _uri):
        pgcursor = conn.cursor()
        sqlinsertitem = "INSERT INTO temp_refs (reference, content, parent, type, docset, uri) VALUES (%s, %s, %s, %s, %s, %s);"
        pgcursor.execute(sqlinsertitem,[_name,
                                        _content,
                                        _parent,
                                        _type,
                                        _docset,
                                        _uri])


    def moveToData(self, conn):
        sqlmovedata = 'INSERT INTO refs (reference, content,uri,parent_uri,type,docset) SELECT reference,content,uri,parent,type, docset FROM temp_refs;'
        pgcursor = conn.cursor()
        pgcursor.execute(sqlmovedata)

    def emptyTable(self, conn, docset):
        sqlemptytables = 'DELETE FROM refs WHERE docset=%s;'
        pgcursor = conn.cursor()
        pgcursor.execute(sqlemptytables, [docset])

    def initTable(self, conn):
        sqlinittable = 'TRUNCATE TABLE temp_refs;'
        pgcursor = conn.cursor()
        pgcursor.execute(sqlinittable)

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
        conn.close()
        print self.docset_name + ' import succeed! \n ' + str(self.total_entries) + ' imported'

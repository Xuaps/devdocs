#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
sys.path.append('../')
import unittest
import pprint
import re
import os
import json
import time
from scrapy.http import HtmlResponse
from refly_scraper.items import ReferenceItem
from importer import DocImporter


class LinkTester(unittest.TestCase):

    links = {}
    link_re = re.compile('href="(?!http:\/\/)([\(\)\*:$_~\+\(\)\!\#\/%\-\w\.]*)"', re.IGNORECASE)
    docset = ''
    haserror = 0
    index_path = ''
    content_path = '../../../public/docs/'
    def testLinks(self):
        self.docset = 'cpp'
        self.index_path = self.content_path + self.docset +  '/index.json'
        json_data = self.processJSON(self.index_path)
        self.links = self.CreateLinkCollection(json_data)
        self.f = open('brokenlinks.log', 'a')
        self.f.write('\n\n\n########################################   ' + self.docset + '   ########################################\n\n\n')
        for entry in json_data:
            if entry['path'].find('#')!= -1:
                 entry['path'] = entry['path'].split('#')[0]
            filename = self.getFileName(self.content_path,self.docset, entry['path'])
            self.filename = filename
            _errors = self.ProcessContent(self.getContent(filename))
        self.f.close()
        self.assertEqual(_errors, 0)

    def ProcessContent(self, content):
        for match in re.findall(self.link_re,content):
            anchor = ''
            keymatch = match.lower().replace('../', '').replace('%24', '$')
            if match.find('#')!=-1 and keymatch not in self.links.keys():
                anchor = keymatch[keymatch.find('#'):]
                keymatch = keymatch[:keymatch.find('#')]
            if keymatch not in self.links:
                self.haserror += 1
                hour = time.strftime("%d/%m/%Y %H:%M:%S")
                self.f.write('-' + keymatch + ' in ' + self.filename + ' at '+ hour + '\n')
        return self.haserror

    def CreateLinkCollection(self, entries):
        links = {}
        for entry in entries:
            if entry['path'].lower() not in links.keys() or entry['anchor']=='':
                links[entry['path'].lower()] = entry['parsed_uri']
            if entry['anchor']!= '':
                links[entry['path'][entry['path'].find('/'):].lower()] = entry['parsed_uri']
                links[(entry['path'] + '#' + entry['anchor']).lower()] = entry['parsed_uri']
                links['#' + entry['anchor'].lower()] = entry['parsed_uri']
            # EXCEPTION FOR EmberJS
            if entry['path'].lower().find('classes/') != -1 and (entry['path'].lower().replace('classes/','') not in links.keys() or entry['anchor']==''):
               links[entry['path'].lower().replace('classes/','')] = entry['parsed_uri']
            # EXCEPTION FOR Haskell
            if entry['docset'].lower() == 'haskell':
               links[entry['path'][entry['path'].find('/')+1:].lower()] = entry['parsed_uri']
            # EXCEPTION FOR Python
            if entry['docset'].lower() == 'python3' or entry['docset'].lower() == 'python2':
               links[entry['path'][entry['path'].find('/')+1:].lower() + '.html'] = entry['parsed_uri']
               links[entry['path'] + '.html'] = entry['parsed_uri']
            # EXCEPTION FOR Chai
            if entry['path'].find('helpers/index') != -1:
               links['helpers/index'] = entry['parsed_uri']
            # EXCEPTION FOR C++
            if entry['docset'].lower() == 'cpp' or entry['docset'].lower() == 'c':
                links[entry['path'][entry['path'].find('/')+1:].lower()] = entry['parsed_uri']
                links[entry['path'].replace('fs/', '').replace('experimental/', '')] = entry['parsed_uri']
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
            raise Exception("'index.json not found in docset " + self.docset)


    def Uris_x_parent_uris(self, docset, json_file):
        importer = DocImporter(docset)
        entries = importer.processJSON(json_file)
        urilist = self.CreateUriList(entries)
        errorcounter = 0
        for entry in entries:
            if entry['parent_uri']!= 'null' and entry['parent_uri'] not in urilist:
                errorcounter += 1
                print 'parent_uri: ' + entry['parent_uri']
        return errorcounter

    def processJSON(self,file_path):
        if os.path.isfile(file_path):
            with open(file_path) as json_file:
                json_data = json.load(json_file)
            self.total_entries = len(json_data['entries'])
            return json_data['entries']
        else:
            raise Exception("'index.json not found in docset " + self.docset)

    def CheckAnchors(self, docset):
         content_path = '../../../public/docs/'
         json_file = content_path + docset + '/index.json'
         importer = DocImporter(docset)
         entries = importer.processJSON(json_file)
         anchornotfound = 0
         for entry in entries:
            path = entry['path']
            if not entry['path'].endswith('.html'):
                path += '.html'
            filename = content_path + docset + '/' + path
            content = importer.getContent(filename)
            if entry['anchor']!= "":
               if content.find('id="' + entry['anchor']+ '"') == -1:
                   anchornotfound += 1
                   print entry['anchor']
         return anchornotfound
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
from lxml import html


class LinkTester(unittest.TestCase):

    links = {}
    docset = 'dom'
    linkerrors = []
    index_path = ''
    content_path = '../../../public/docs/'
    def testLinks(self):
        self.index_path = self.content_path + self.docset +  '/index.json'
        json_data = self.processJSON(self.index_path)
        self.links = self.CreateLinkCollection(json_data)
        for entry in json_data:
            if entry['path'].find('#')!= -1:
                 entry['path'] = entry['path'].split('#')[0]
            filename = self.getFileName(self.content_path,self.docset, entry['path'])
            self.filename = filename
            print '################# ' + filename + ' ###################'
            self.ProcessContent(self.getContent(filename))
        if len(self.linkerrors)>0:
            brokenlinksfile = open('brokenlinks_' + self.docset +'.log', 'a')
            hour = time.strftime("%d/%m/%Y %H:%M:%S")
            brokenlinksfile.write('\n\n\n########################################  ' + hour + '   -   ' + self.docset + '   ########################################\n\n\n')
            for error in self.linkerrors:
                brokenlinksfile.write(error + '\n')
            brokenlinksfile.close()
        self.assertEqual(len(self.linkerrors), 0)

    def ProcessContent(self, content):
        tree = html.fromstring(content)
        links = tree.xpath('//a[@href]')
        for alink in links:
            anchor = ''
            keymatch = ''
            if alink.get('href')!=None:
                match = alink.get('href')
                keymatch = match.lower().replace('../', '')
            else:
                match = '#'
                keymatch = '#'
            if not keymatch.startswith('http://') and not keymatch.startswith('https://') and not keymatch.startswith('ftp://') and not keymatch.startswith('irc://') and not keymatch.startswith('news://') and not keymatch.startswith('mailto:'):
                if match.find('#')!=-1 and keymatch not in self.links.keys():
                    anchor = keymatch[keymatch.find('#'):]
                    keymatch = keymatch[:keymatch.find('#')]
                if keymatch in self.links.keys():
                    #print '"' + keymatch + '" - "' + match + '" : "' + self.links[keymatch] + '"'
                    content = content.replace('"' + match + '"', '"' + self.links[keymatch] + anchor + '"',1)
                if keymatch not in self.links and anchor == '' and alink.get('class') != 'broken':
                    hour = time.strftime("%d/%m/%Y %H:%M:%S")
                    self.linkerrors.append('- "' + keymatch + '" in ' + self.filename)

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
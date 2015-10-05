from importer import DocImporter
from collections import OrderedDict
import sys
import time
import subprocess, shlex
import ConfigParser
import pprint

class Scraper():

    def __init__(self, _docset, config_file):
        self.config = ConfigParser.ConfigParser()
        config_file = 'importer.cfg'
        self.config.read(config_file)
        unorderedsections = self.config.sections()
        if _docset!='':
            sections = [{'name':_docset, 'sort': 0}]
        else:
            sections = self.sortSections(unorderedsections)
        self.downloadZips(sections)
        self.scrapDocsets(sections)

    def sortSections(self, sectlist):
    	newlist = []
        for sect in sectlist:
        	if sect not in ['Connection', 'Config', 'Path']:
	            newitem ={
	                'name' : sect,
	                'sort': int(self.config.get(sect, 'sort'))
	            }
	            newlist.append(newitem)
        orderedsections = sorted(newlist, key=lambda key_value: key_value['sort'])
        return orderedsections


    def downloadZips(self, docsetlist):
        working_directory = '../../../'
        for sect in docsetlist:
            if self.config.get(sect['name'], 'zip_url')!= '':
                if self.config.get(sect['name'], 'active') == 'true':
                    scraper_name = self.config.get(sect['name'], 'scraper_name')
                    zip_url = self.config.get(sect['name'], 'zip_url')
                    if zip_url.endswith('.tar.gz'):
                        extension = 'tar.gz'
                    else:
                        extension = zip_url.split('.')[-1]
                    try:
                        print "Downloading " + zip_url + "..."
                        subprocess.check_output("wget " + zip_url + " -O ./file_scraper_docs/" + scraper_name + "." + extension, shell=True, stderr=subprocess.STDOUT, cwd=working_directory)
                        if extension == 'zip':
                            print "Extracting " + scraper_name + "." + extension + "..."
                            subprocess.check_output("unzip -o ./file_scraper_docs/" + scraper_name + ".zip -d ./file_scraper_docs/"+ scraper_name + "/", shell=True, stderr=subprocess.STDOUT, cwd=working_directory)
                        else:
                            print "Extracting " + scraper_name + "." + extension + "..."
                            subprocess.check_output("mkdir -p ./file_scraper_docs/" + scraper_name + " && tar -zxvf ./file_scraper_docs/" + scraper_name + ".tar.gz -C ./file_scraper_docs/" + scraper_name, shell=True, stderr=subprocess.STDOUT, cwd=working_directory)
                        print 'done'
                    except subprocess.CalledProcessError, e:
                        hour = time.strftime("%d/%m/%Y %H:%M:%S")
                        scraper_errors_file = open('scraper_errors.log', 'a')
                        message = "error downloading " + zip_url + " at" + hour + "\n\n" + e.output + "###########################################\n\n\n"
                        scraper_errors_file.write(message)
                        scraper_errors_file.close()

    def scrapDocsets(self, docsetlist):
        working_directory = '../../../'
        for sect in docsetlist:
            if self.config.get(sect['name'], 'active') == 'true':
                scraper_name = self.config.get(sect['name'], 'scraper_name')
                print "Processing " + scraper_name + "..."
                try:
                    thorcommand = "thor docs generate " + scraper_name + " --force"
                    args = shlex.split(thorcommand)
                    subprocess.check_output(args, stderr=subprocess.STDOUT, cwd=working_directory)
                    print 'done'
                except subprocess.CalledProcessError, e:
                    hour = time.strftime("%d/%m/%Y %H:%M:%S")
                    scraper_errors_file = open('scraper_errors.log', 'a')
                    message = "error scrapping " + scraper_name + " at" + hour + "\n\n" + e.output + "###########################################\n\n\n"
                    scraper_errors_file.write(message)
                    scraper_errors_file.close()
                except Exception, e:
                    hour = time.strftime("%d/%m/%Y %H:%M:%S")
                    scraper_errors_file = open('scraper_errors.log', 'a')
                    message = "error scrapping " + scraper_name + " at" + hour + "\n\n" + str(e) + "###########################################\n\n\n"
                    scraper_errors_file.write(message)
                    scraper_errors_file.close()

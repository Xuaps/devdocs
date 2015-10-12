from importer import DocImporter
from scraper import Scraper
import sys
import time
def main(argv):
    print 'process started at ' + time.strftime("%d/%m/%Y %H:%M:%S")
    docset = ''
    mode = ''
    action = ''
    connstring = ''
    for arg in argv:
        if arg[:2]== '-a':
            action = arg[2:]
        elif arg[:2]== '-d':
            docset = arg[2:]
        elif arg[:2]== '-m':
            mode = arg[2:]
        elif arg[:3]== '-cs':
            connstring = arg[3:]

    if mode=='' and docset!='':
        mode = 'single'
    if action == 'import':
      importer = DocImporter(docset, mode, connstring)
    elif action == 'scrap':
      scraper = Scraper(docset, 'importer.cfg')
    else:
      scraper = Scraper(docset,'importer.cfg')
      importer = DocImporter(docset, mode, connstring)
    print 'process finished at ' + time.strftime("%d/%m/%Y %H:%M:%S")

if __name__ == "__main__":
    main(sys.argv[1:])

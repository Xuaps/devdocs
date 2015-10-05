from importer import DocImporter
from scraper import Scraper
import sys
def main(argv):
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

    if action == 'import':
      if mode=='' and docset!='':
          mode = 'single'
      importer = DocImporter(docset, mode, connstring)
    elif action == 'scrap':
      scraper = Scraper(docset, 'importer.cfg')
    else:
      scraper = Scraper(docset,'importer.cfg')
      importer = DocImporter(docset, mode, connstring)

if __name__ == "__main__":
    main(sys.argv[1:])

from importer import DocImporter
import sys
def main(argv):
    if len(argv)>0:
        importer = DocImporter(unicode(argv[0]))
        importer.importToDB()
    else:
        importer = DocImporter(u'all')
if __name__ == "__main__":
	main(sys.argv[1:])

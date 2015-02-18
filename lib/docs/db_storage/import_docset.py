from importer import DocImporter
import sys
def main(argv):
    importer = DocImporter(unicode(argv[0]))
    importer.importToDB()
if __name__ == "__main__":
	main(sys.argv[1:])

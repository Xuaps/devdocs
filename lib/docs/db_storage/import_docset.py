from importer import DocImporter
import sys
def main(argv):
    docset = ''
    mode = 'all'
    connstring = ''
    for arg in argv:
        if arg[:2]== '-m':
		    mode = arg[2:]
        elif arg[:2]== '-d':
		    docset = arg[2:]
        elif arg[:3]== '-cs':
		    connstring = arg[3:]
    if docset!='':
        mode = 'single'
    importer = DocImporter(docset, mode, connstring)

if __name__ == "__main__":
	main(sys.argv[1:])

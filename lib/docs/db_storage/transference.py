#!/usr/bin/python
import psycopg2
import sys

def main(argv):
  connection_string = "host='localhost' dbname='slashdb' user='postgres'"
 
  connection = psycopg2.connect(connection_string)
  pgcursor = connection.cursor()
  queryfirstref = "SELECT docset, uri FROM temp_refs LIMIT 1"
  queryrefsinsert = """
        INSERT INTO refs (reference, content,uri,parent_uri,type,docset)
        SELECT reference,content,uri,parent,type, docset FROM temp_refs
        """
  queryrefsdelete = "DELETE FROM refs WHERE docset=%s"
  querytruncatetemp_refs = "TRUNCATE TABLE temp_refs"
  querytruncatesource_refs = "TRUNCATE TABLE source_refs"
  
  querydocsetselect = "SELECT docset FROM docsets WHERE docset = %s"
  querydocsetinsert = "INSERT INTO docsets (docset, default_uri, pub_date, update_date, active) VALUES (%s,%s,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,%s)"
  querydocsetupdate = "UPDATE docsets SET update_date = CURRENT_TIMESTAMP WHERE docset = %s"

  pgcursor.execute(queryfirstref)
  refsrow = pgcursor.fetchone()
  if len(argv)>0:
      if unicode(argv[0]) == u'overrides':
          pgcursor.execute(queryrefsdelete,[refsrow[0]])

  pgcursor.execute(queryrefsinsert)
  pgcursor.execute(querydocsetselect,[refsrow[0]])
  docsetsrow = pgcursor.fetchone()
  if docsetsrow:
      pgcursor.execute(querydocsetupdate, [refsrow[0]])
  else:
      pgcursor.execute(querydocsetinsert,[refsrow[0], refsrow[1], True])

  pgcursor.execute(querytruncatetemp_refs)
  pgcursor.execute(querytruncatesource_refs)
  print "Transfer completed!\n"
  connection.commit() 
if __name__ == "__main__":
	main(sys.argv[1:])


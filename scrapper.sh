#!/bin/bash
date=`/bin/date "+%d/%m/%Y -%H:%M:%S"`
echo "scrapping started at $date"
OUTPUTLOG='errors.log'
for docset in backbone bower c chai cordova cpp css d3 dom dom_events ember express git go grunt html http haskell jquery_core jquery_ui jquery_mobile javascript less lodash markdown modernizr moment mongoosejs nginx node php2 phpunit postgresql python2 python react redis requirejs sass sinon socketio svg underscore xpath yii
do
	if thor docs:generate $docset --force
	then
	  echo "docset $docset scrapped!"
	else
	  date=`/bin/date "+%d/%m/%Y -%H:%M:%S"`
	  echo "docset $docset not scrapped!"
	  printf "$date docset $docset not scrapped!\n" >> $OUTPUTLOG
	fi
done
date=`/bin/date "+%d/%m/%Y -%H:%M:%S"`
echo "scrapping finished at $date"
export DYLD_FALLBACK_LIBRARY_PATH=/Library/PostgreSQL/9.4/lib/
cd lib/docs/db_storage/
python import_docset.py
date=`/bin/date "+%d/%m/%Y -%H:%M:%S"`
echo "import finished at $date"

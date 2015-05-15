#!/bin/bash
NAME=(c python2 python3 django)
URLS=(http://upload.cppreference.com/mwiki/images/6/6c/html_book_20141118.tar.gz https://docs.python.org/2.7/archives/python-2.7.10rc0-docs-html.zip https://docs.python.org/3/archives/python-3.4.3-docs-html.zip https://docs.djangoproject.com/m/docs/django-docs-1.8-en.zip)
for i in {0..3}
do
	if [ `echo ${URLS[$i]} | grep -c ".zip" ` -gt 0 ]
	then
	    wget ${URLS[$i]} -O ./file_scraper_docs/${NAME[$i]}.zip
	    unzip -o ./file_scraper_docs/${NAME[$i]}.zip -d ./file_scraper_docs/${NAME[$i]}/
    elif [ `echo ${URLS[$i]} | grep -c ".tar.gz" ` -gt 0 ]
    then
        wget ${URLS[$i]} -O ./file_scraper_docs/${NAME[$i]}.tar.gz
        mkdir -p ./file_scraper_docs/${NAME[$i]} && tar -zxvf ./file_scraper_docs/${NAME[$i]}.tar.gz -C ./file_scraper_docs/${NAME[$i]}
    fi
done
mv ./file_scraper_docs/python2/* ./file_scraper_docs/python2/docs
mv ./file_scraper_docs/python3/* ./file_scraper_docs/python3/docs

date=`/bin/date "+%d/%m/%Y -%H:%M:%S"`
echo "scrapping started at $date"
OUTPUTLOG='errors.log'
for docset in angular backbone bower c chai coffeescript cordova cpp css d3 django dom dom_events ember express git go grunt html http haskell jquery_core jquery_ui jquery_mobile javascript knockout laravel less lodash marionette markdown modernizr maxcdn moment mongoosejs nginx node nokogiri2 npm php2 phpunit postgresql python2 python rails react redis requirejs rethinkdb ruby sass sinon socketio svg underscore xpath yii
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
echo "import started at $date"
python import_docset.py
date=`/bin/date "+%d/%m/%Y -%H:%M:%S"`
echo "import finished at $date"

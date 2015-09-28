#!/bin/bash
if [ $1 == "scrap" ] || [ $1 == "fullprocess" ] || [ $1 == "download" ]
then
    if [ $1 == "scrap" ] || [ $1 == "download" ] || [ $1 == "fullprocess" ]
    then
		NAME=(c python2 python3 django)
		URLS=(http://upload.cppreference.com/mwiki/images/6/6c/html_book_20141118.tar.gz https://docs.python.org/2.7/archives/python-2.7.8-docs-html.zip https://docs.python.org/3/archives/python-3.5.0-docs-html.zip https://docs.djangoproject.com/m/docs/django-docs-1.8-en.zip)
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
		mv ./file_scraper_docs/python2/python-2.7.8-docs-html ./file_scraper_docs/python2/docs
		mv ./file_scraper_docs/python3/python-3.5.0-docs-html ./file_scraper_docs/python3/docs

		date=`/bin/date "+%d/%m/%Y -%H:%M:%S"`
		echo "scrapping started at $date"
		OUTPUTLOG='errors.log'
    fi
    if [ $1 == "fullprocess" ] || [ $1 == "scrap" ]
    then
		for docset in angular apache backbone bower browserify c chai clojure coffeescript cordova cpp css d3 django dom drupal ember express git go grunt html http haskell iojs jasmine jest dom_events jquery_core jquery_ui jquery_mobile javascript knockout laravel less lodash lua marionette markdown mocha modernizr moment mongoose nginx node nokogiri2 npm opentsdb phalcon phaser php2 phpunit postgresql python2 python q rails react react_native react_router redis reflux requirejs rethinkdb ruby rust sass sinon socketio svg symfony underscore vue webpack xpath yii yii1
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
    fi
fi

if [ $1 == "import" ] || [ $1 == "fullprocess" ]
then

	export DYLD_FALLBACK_LIBRARY _PATH=/Library/PostgreSQL/9.4/lib/
	cd lib/docs/db_storage/
	docset=`cat lastimport.log`
	if [ -n "$docset" ] && [ $1 == "import" ];
	then
	    read -n1 -p "continue from $docset? [y,n]" input 
	    if [[ $input == "Y" || $input == "y" ]]; then
	        python import_docset.py -d$docset -mcontinue -cs$2
	    else
	    	python import_docset.py -mall -cs$2
	    fi
	else
		python import_docset.py -mall -cs$2
    fi
	echo "import started at $date"
	date=`/bin/date "+%d/%m/%Y -%H:%M:%S"`
	echo "import finished at $date"
fi

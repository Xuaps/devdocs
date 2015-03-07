module Docs
  class Php
    class EntriesFilter < Docs::EntriesFilter
      TYPE_BY_NAME_STARTS_WITH = {
        'ArrayObject'     => 'SPL',
        'Collectable'     => 'pthreads',
        'Cond'            => 'pthreads',
        'CURL'            => 'cURL',
        'Date'            => 'Date/Time',
        'ErrorException'  => 'Predefined Exceptions',
        'Exception'       => 'Predefined Exceptions',
        'Json'            => 'JSON',
        'Http'            => 'HTTP',
        'Mutex'           => 'pthreads',
        'php_user_filter' => 'Stream',
        'Pool'            => 'pthreads',
        'Reflector'       => 'Reflection',
        'Soap'            => 'SOAP',
        'SplFile'         => 'SPL/File',
        'SplTempFile'     => 'SPL/File',
        'Spl'             => 'SPL',
        'Stackable'       => 'pthreads',
        'streamWrapper'   => 'Stream',
        'Thread'          => 'pthreads',
        'tidy'            => 'Tidy',
        'Worker'          => 'pthreads',
        'XsltProcessor'   => 'XSLT',
        'ZipArchive'      => 'Zip' }

      %w(APC Directory DOM Gearman Gmagick Imagick mysqli OAuth PDO Reflection
        Session SimpleXML Solr Sphinx SQLite3 Varnish XSLT Yaf).each do |str|
        TYPE_BY_NAME_STARTS_WITH[str] = str
      end

      %w(ArrayAccess Closure Generator Iterator IteratorAggregate Serializable Traversable).each do |str|
        TYPE_BY_NAME_STARTS_WITH[str] = 'Predefined Interfaces and Classes'
      end

      %w(Collator grapheme idn Intl intl Locale MessageFormatter Normalizer
         NumberFormatter ResourceBundle Spoofchecker Transliterator UConverter).each do |str|
        TYPE_BY_NAME_STARTS_WITH[str] = 'Internationalization'
      end

      %w(Countable OuterIterator RecursiveIterator SeekableIterator ).each do |str|
        TYPE_BY_NAME_STARTS_WITH[str] = 'SPL/Interfaces'
      end

      REPLACE_TYPES = {
        'Exceptions'        => 'SPL/Exceptions',
        'GD and Image'      => 'Image',
        'Gmagick'           => 'Image/GraphicsMagick',
        'Imagick'           => 'Image/ImageMagick',
        'Interfaces'        => 'SPL/Interfaces',
        'Iterators'         => 'SPL/Iterators',
        'mysqli'            => 'Database/MySQL',
        'PostgreSQL'        => 'Database/PostgreSQL',
        'Session'           => 'Sessions',
        'Session PgSQL'     => 'Database/PostgreSQL',
        'SQLite3'           => 'Database/SQLite',
        'SQLSRV'            => 'Database/SQL Server',
        'Stream'            => 'Streams',
        'Yaml'              => 'YAML' }


      def get_name

        return 'IntlException' if slug == 'class.intlexception'
        name = css('> .sect1 > .title', 'h1', 'h2').first.content
        name.remove! 'The '
        name.sub! ' class', ' (class)'
        name.sub! ' interface', ' (interface)'
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + path
        parsed_uri
      end

      def get_parent_uri
        subpath = *path.split('/')
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            parent_uri = 'null'
        end
      end

      def get_type
        if slug.include? 'types'
            'type'
        elsif slug.include? 'interface'
            'interface'
        elsif slug.include? 'variables'
            'variable'
        elsif slug.include? 'language.constants'
            'constant'
        elsif slug.include? 'appendices'
            'interface'
        elsif slug.include? 'migration'
            'guide'
        elsif slug.include? 'faq'
            'guide'
        elsif slug.include? ' install'
            'guide'
        elsif slug.include? 'basic'
            'guide'
        elsif slug.include? 'language.expressions.'
            'guide'
        elsif slug.include? 'language.operators.'
            'guide'
        elsif slug.include? 'control-structures.'
            'function'
        elsif slug.include? 'funcs.'
            'function'
        elsif slug.include? 'cairocontext.'
            'function'
        elsif slug.include? 'function.'
            'function'
        elsif slug.include? 'language.oop5'
            'class'
        elsif slug.include? 'class.'
            'class'
        elsif slug.include? 'language.namespaces.'
            'namespace'
        elsif slug.include? 'language.exceptions.'
            'class'
        elsif slug.include? 'language.references.'
            'guide'
        elsif slug.include? 'operators.'
            'variable'
        elsif slug.include? 'context.'
            'guide'
        elsif slug.include? '::.'
            'method'
        elsif slug.include? 'wrappers.'
            'class'
        else
            'others'
        end
      end

      def include_default_entry?
        !initial_page? && doc.at_css('.reference', '.refentry', '.sect1')
      end
    end
  end
end

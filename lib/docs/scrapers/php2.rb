module Docs
  class Php2 < UrlScraper
    self.name = 'PHP'
    self.type = 'php'
    self.version = 'up to 5.6.2'
    self.base_url = 'http://php.net/manual/en/'
    self.root_path = 'index.php'
    self.initial_paths = %w(
      reserved.variables.php
      spl.iterators.php
      funcref.php
      langref.php
      ref.bbcode.php
      ref.filesystem.php
      ref.url.php
      ref.info.php
      ref.fann.php
      refs.database.php
      refs.math.php
      ref.apache.php
      ref.strings.php
      ref.apc.php
      ref.apd.php
      ref.array.php
      eventbufferevent.construct.php
      eventbufferevent.setcallbacks.php
      set.mysqlinfo.php
      language.control-structures.php
      reserved.exceptions.php
      reserved.interfaces.php)

    html_filters.push 'php2/entries', 'php2/clean_html', 'title'
    text_filters.push 'php2/fix_urls'

    options[:title] = false
    options[:root_title] = 'PHP'
    options[:docset_uri] = '/php'

    #options[:skip_links] = ->(filter) { !filter.initial_page? }

    options[:skip_patterns] = [/mysqlnd/]
    options[:skip] = ['php_manual.php','indexes.examples.php', 'url.mongodb.dochub.maxWriteBatchSize', 'url.imagemagick.usage.color_mods.sigmoidal','url.mongodb.dochub.maxbsonobjectsize']

    options[:attribution] = <<-HTML
      &copy; 1997&ndash;2014 The PHP Documentation Group<br>
      Licensed under the Creative Commons Attribution License v3.0 or later.
    HTML

    options[:fix_urls] = ->(url) do
      url.sub! 'http://php.net/manual/en/language.types.string.php#language.types.string.parsing.complex', 'http://php.net/manual/en/language.types.string.php'
      url.sub! 'http://php.net/manual/en/language.pseudo-types.php#language.types.mixed', 'http://php.net/manual/en/language.pseudo-types.php#language.types.mixed'
      url
    end
  end
end

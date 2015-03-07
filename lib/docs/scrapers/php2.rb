module Docs
  class Php2 < UrlScraper
    self.name = 'PHP'
    self.type = 'php'
    self.version = 'up to 5.6.2'
    self.base_url = 'http://php.net/manual/en/'
    self.root_path = 'index.html'
    self.initial_paths = %w(
      reserved.variables.php
      funcref.php
      refs.database.php
      set.mysqlinfo.php
      language.control-structures.php
      reserved.exceptions.php
      reserved.interfaces.php)

    html_filters.push 'php2/internal_urls', 'php2/entries', 'php2/clean_html', 'title'
    text_filters.push 'php2/fix_urls'

    options[:title] = false
    options[:root_title] = 'PHP'
    options[:docset_uri] = '/php'

    options[:skip_links] = false

    options[:skip_patterns] = [/mysqlnd/]

    options[:attribution] = <<-HTML
      &copy; 1997&ndash;2014 The PHP Documentation Group<br>
      Licensed under the Creative Commons Attribution License v3.0 or later.
    HTML
  end
end

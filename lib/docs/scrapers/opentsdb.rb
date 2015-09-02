module Docs
  class Opentsdb < UrlScraper
    self.name = 'OpenTSDB'
    self.type = 'opentsdb'
    self.version = '2.1.0'
    self.base_url = 'http://opentsdb.net/docs/build/html/'
    self.root_path = 'index.html'

    html_filters.push 'opentsdb/entries', 'opentsdb/clean_html'
    options[:domain] = 'http://www.refly.xyz'
    options[:docset_uri] = '/opentsdb'
    options[:root_title] = 'OpenTSDB'
    options[:skip] = %w(genindex.html search.html)

    options[:attribution] = <<-HTML
      &copy; 2010&ndash;2015 The OpenTSDB Authors<br>
      Licensed under the GNU LGPLv2.1+ and GPLv3+ licenses.
    HTML
  end
end

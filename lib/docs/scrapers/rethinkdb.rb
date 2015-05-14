module Docs
  class Rethinkdb < UrlScraper
    self.name = 'RethinkDB'
    self.type = 'rethinkdb'
    self.version = '2.0.1'
    self.base_url = 'http://rethinkdb.com/api/javascript/'

    html_filters.push 'rethinkdb/entries', 'rethinkdb/clean_html'

    options[:domain] = 'http://www.refly.co'
    options[:root_title] = 'RethinkDB'
    options[:docset_uri] = '/rethinkdb'
    options[:trailing_slash] = false
    options[:container] = '.docs-article'

    options[:fix_urls] = ->(url) do
      url.sub! %r{rethinkdb.com/api/(?!javascript|ruby|python)}, 'rethinkdb.com/api/javascript/'
    end

    options[:attribution] = <<-HTML
      &copy; RethinkDB contributors<br>
      Licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
    HTML
  end
end
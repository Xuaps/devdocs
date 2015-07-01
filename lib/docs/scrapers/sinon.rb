module Docs
  class Sinon < UrlScraper
    self.name = 'Sinon'
    self.type = 'sinon'
    self.version = '1.12.1'
    self.base_url = 'http://sinonjs.org/docs/'
    html_filters.push 'sinon/clean_html', 'sinon/entries', 'title'

    options[:domain] = 'http://www.refly.xyz'
    options[:title] = 'Sinon.JS'
    options[:container] = '.docs'
    options[:root_title] = 'SinonJS'
    options[:docset_uri] = '/sinonjs'
    options[:skip_links] = true

    options[:attribution] = <<-HTML
      &copy; 2010&ndash;2014 Christian Johansen<br>
      Licensed under the BSD License.
    HTML
  end
end

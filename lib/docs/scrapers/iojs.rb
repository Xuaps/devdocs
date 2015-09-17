module Docs
  class Iojs < UrlScraper
    self.name = 'io.js'
    self.slug = 'iojs'
    self.type = 'node'
    self.version = '3.2.0'
    self.base_url = 'https://iojs.org/api/'

    html_filters.push 'node/clean_html', 'node/entries', 'title'

    options[:title] = false
    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'ioJS'
    options[:docset_uri] = '/iojs'
    options[:container] = '#apicontent'
    options[:skip] = %w(index.html all.html documentation.html synopsis.html)

    options[:attribution] = <<-HTML
      &copy; io.js contributors<br>
      Licensed under the MIT License.
    HTML
  end
end

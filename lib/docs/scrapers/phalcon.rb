module Docs
  class Phalcon < UrlScraper
    self.type = 'phalcon'
    self.version = '2.0.6'
    self.base_url = 'https://docs.phalconphp.com/en/latest/'
    self.root_path = 'index.html'

    html_filters.push 'phalcon/clean_html', 'phalcon/entries'

    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Phalcon'
    options[:docset_uri] = '/phalcon'
    options[:only_patterns] = [/reference\//, /api\//]
    options[:skip] = %w(
      api/index.html
      reference/license.html)

    options[:attribution] = <<-HTML
      &copy; 2011&ndash;2015 Phalcon Framework Team<br>
      Licensed under the Creative Commons Attribution License 3.0.
    HTML
  end
end

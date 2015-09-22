module Docs
  class Jest < UrlScraper
    self.name = 'Jest'
    self.type = 'jest'
    self.version = '0.5.6'
    self.base_url = 'https://facebook.github.io/jest/'
    self.root_path = 'docs/getting-started.html'
    html_filters.push 'jest/entries', 'jest/clean_html'

    options[:domain] = 'http://www.refly.xyz'
    options[:container] = '.documentationContent'
    options[:root_title] = 'Jest'
    options[:docset_uri] = '/jest'
    options[:only_patterns] = [/\Adocs\//, /\Atips\//]
    options[:skip] = %w()

    options[:attribution] = <<-HTML
      &copy; 2013&ndash;2014 Facebook Inc.<br>
      Licensed under BSD License.
    HTML
  end
end

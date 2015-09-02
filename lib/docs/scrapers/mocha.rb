module Docs
  class Mocha < UrlScraper
    self.name = 'mocha'
    self.type = 'mocha'
    self.version = '2.2.1'
    self.base_url = 'http://mochajs.org/'

    html_filters.push 'mocha/entries', 'mocha/clean_html', 'title'

    options[:container] = '#content'
    options[:title] = 'mocha'
    options[:domain] = 'http://www.refly.xyz'
    options[:docset_uri] = '/mocha'
    options[:root_title] = 'Mocha'
    options[:skip_links] = true

    options[:attribution] = <<-HTML
      &copy; 2011&ndash;2015 TJ Holowaychuk<br>
      Licensed under the MIT License.
    HTML
  end
end

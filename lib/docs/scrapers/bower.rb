module Docs
  class Bower < UrlScraper
    self.name = 'Bower'
    self.type = 'bower'
    self.version = '1.4.1'
    self.base_url = 'http://bower.io/docs/'
    self.root_path = 'api/'

    html_filters.push 'bower/clean_html', 'bower/entries'

    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Bower'
    options[:docset_uri] = '/bower'
    options[:trailing_slash] = false
    options[:skip] = %w(tools about)

    options[:attribution] = <<-HTML
      &copy; 2014 Bower contributors<br>
      Licensed under the Creative Commons Attribution License.
    HTML

  end
end

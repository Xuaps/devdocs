module Docs
  class Coffeescript < UrlScraper
    self.name = 'CoffeeScript'
    self.type = 'coffeescript'
    self.version = '1.10.0'
    self.base_url = 'http://coffeescript.org'
    self.root_path = 'index.html'

    html_filters.push 'coffeescript/clean_html', 'coffeescript/entries', 'title'

    options[:domain] = 'http://www.refly.xyz'
    options[:title] = 'CoffeeScript'
    options[:container] = '.container'
    options[:root_title] = 'CoffeeScript'
    options[:docset_uri] = '/coffeescript'
    options[:skip_links] = true

    options[:attribution] = <<-HTML
      &copy; 2009&ndash;2014 Jeremy Ashkenas<br>
      Licensed under the MIT License.
    HTML
  end
end

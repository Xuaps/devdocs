module Docs
  class Bootstrap < UrlScraper
    self.name = 'Bootstrap'
    self.type = 'Bootstrap'
    self.version = '3.3.35'
    self.base_url = 'http://getbootstrap.com/'
    self.root_path = '/getting-started/'

    html_filters.push 'bootstrap/entries', 'bootstrap/clean_html'

    options[:domain] = 'http://www.refly.xyz'
    options[:container] = '.container.bs-docs-container'
    options[:trailing_slash] = true
    options[:root_title] = 'Bootstrap'
    options[:docset_uri] = '/bootstrap'
    options[:only] = [
      'javascript/',
      'css/',
      'components/',
      'getting-started/'
    ]

    options[:attribution] = <<-HTML
      &copy; 2015 Rackt<br>
      Licensed under the MIT License.
    HTML

  end
end

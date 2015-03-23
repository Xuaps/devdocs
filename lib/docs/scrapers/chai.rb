module Docs
  class Chai < UrlScraper
    self.name = 'Chai'
    self.type = 'chai'
    self.version = '1.10.0'
    self.base_url = 'http://chaijs.com'
    self.root_path = '/api/'
    self.initial_paths = %w(/guide/installation/ /api/bdd/)

    html_filters.push 'chai/entries', 'chai/clean_html'

    options[:container] = '#content'
    options[:trailing_slash] = true
    options[:root_title] = 'Chai'
    options[:docset_uri] = '/chai'

    options[:only_patterns] = [/\A\/guide/, /\A\/api/]
    options[:skip] = %w(/api/test/ /guide/ /guide/resources/)

    options[:attribution] = <<-HTML
      &copy; 2011&ndash;2014 Jake Luer<br>
      Licensed under the MIT License.
    HTML

  end
end

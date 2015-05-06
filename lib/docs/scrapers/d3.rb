module Docs
  class D3 < UrlScraper
    self.name = 'D3.js'
    self.slug = 'd3'
    self.type = 'd3'
    self.version = '3.5.2'
    self.base_url = 'https://github.com/mbostock/d3/wiki/'
    self.root_path = 'API-Reference'

    html_filters.push 'd3/clean_html', 'd3/entries'

    options[:domain] = 'http://www.refly.co'
    options[:container] = '#wiki-wrapper'
    options[:root_title] = 'D3'
    options[:docset_uri] = '/d3'

    options[:only] = %w(
      Selections
      Transitions
      Arrays
      Math
      Requests
      Formatting
      CSV
      Localization
      Colors
      Namespaces
      Internals)

    options[:only_patterns] = [
      /\-Scales\z/,
      /\ASVG\-/,
      /\ATime\-/,
      /\-Layout\z/,
      /\AGeo\-/,
      /\-Geom\z/,
      /\-Behavior\z/]

    options[:skip_patterns] = [/\//]

    options[:attribution] = <<-HTML
      &copy; 2014 Michael Bostock<br>
      Licensed under the BSD License.
    HTML
  end
end

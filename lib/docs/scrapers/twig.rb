module Docs
  class Twig < UrlScraper
    self.name = 'Twig'
    self.type = 'twig'
    self.version = '5.7'
    self.base_url = 'http://twig.sensiolabs.org/api/master/'
    self.root_path = 'classes.html'
    html_filters.push 'twig/entries', 'twig/clean_html'

    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Twig'
    options[:docset_uri] = '/twig'
    options[:skips]= %w(/traits.html)
    options[:attribution] = <<-HTML
      &copy; 2009-2015 Twig Team<br>
      Licensed under the Creative Commons License.
    HTML

  end
end

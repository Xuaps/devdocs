module Docs
  class Symfony < UrlScraper
    self.name = 'Symfony'
    self.slug = 'symfony'
    self.type = 'laravel'
    self.version = '2.7'
    self.base_url = "http://api.symfony.com/#{version}/"
    self.root_path = 'namespaces.html'
    self.initial_paths = %w(classes.html)

    html_filters.push 'symfony/entries', 'symfony/clean_html'

    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Symfony'
    options[:docset_uri] = '/symfony'
    options[:skip] = %w(
      panel.html
      namespaces.html
      interfaces.html
      traits.html
      doc-index.html
      search.html
      Symfony.html)

    options[:attribution] = <<-HTML
      &copy; 2004&ndash;2015 Fabien Potencier<br>
      Licensed under the MIT License.
    HTML
  end
end

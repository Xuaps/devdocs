module Docs
  class Requirejs < UrlScraper
    self.name = 'RequireJS'
    self.type = 'requirejs'
    self.version = '2.1.18'
    self.base_url = 'http://requirejs.org/docs/'
    self.initial_paths = %w(
      api.html
      optimization.html
      jquery.html
      node.html
      dojo.html
      commonjs.html
      plugins.html
      why.html
      whyamd.html)
    html_filters.push 'requirejs/clean_html', 'requirejs/entries'

    options[:domain] = 'http://www.refly.xyz'
    options[:container] = '#content'
    options[:root_title] = 'RequireJS'
    options[:docset_uri] = '/requirejs'
    options[:follow_links] = false
    options[:only] = self.initial_paths

    options[:attribution] = <<-HTML
      &copy; 2010&ndash;2014 The Dojo Foundation<br>
      Licensed under the MIT License.
    HTML
  end
end

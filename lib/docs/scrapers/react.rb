module Docs
  class React < UrlScraper
    self.name = 'React'
    self.type = 'react'
    self.version = '0.13.3'
    self.base_url = 'http://facebook.github.io/react/'
    self.root_path = 'docs/getting-started.html'
    html_filters.push 'react/entries', 'react/clean_html'

    options[:domain] = 'http://www.refly.xyz'
    options[:container] = '.documentationContent'
    options[:root_title] = 'React'
    options[:docset_uri] = '/react'
    options[:only_patterns] = [/\Adocs\//, /\Atips\//]
    options[:skip] = %w(
      docs/
      docs/videos.html
      docs/complementary-tools.html
      docs/examples.html
      docs/conferences.html
      tips/introduction.html)

    options[:attribution] = <<-HTML
      &copy; 2013&ndash;2014 Facebook Inc.<br>
      Licensed under the Creative Commons Attribution 4.0 International Public License.
    HTML
  end
end

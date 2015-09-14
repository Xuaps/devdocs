module Docs
  class Webpack < UrlScraper
    self.name = 'webpack'
    self.type = 'webpack'
    self.version = '1.12'
    self.base_url = 'https://webpack.github.io/docs/'


    html_filters.push 'webpack/entries', 'webpack/clean_html', 'title'

    options[:title] = false
    options[:domain] = 'http://www.refly.xyz'
    options[:title] = false
    options[:root_title] = 'Webpack'
    options[:docset_uri] = '/webpack'
    options[:skip] = %w(list-of-tutorials.html examples.html changelog.html ideas.html roadmap.html)

    options[:attribution] = <<-HTML
      &copy; 2012&ndash;2015 Tobias Koppers<br>
      Licensed under the MIT License.
    HTML
  end
end

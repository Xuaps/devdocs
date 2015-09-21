module Docs
  class Reflux < UrlScraper
    self.name = 'Reflux'
    self.type = 'reflux'
    self.version = '0.2.12'
    self.base_url = 'https://github.com/reflux/refluxjs/blob/master/README.md'

    html_filters.push 'reflux/entries', 'reflux/clean_html'

    options[:domain] = 'http://www.refly.xyz'
    options[:container] = 'article'
    options[:trailing_slash] = true
    options[:root_title] = 'Reflux'
    options[:docset_uri] = '/reflux'

    options[:skip] = %w(/graphs/contributors/ /blob/master/LICENSE.md/)
    options[:attribution] = <<-HTML
      &copy; 2014 Arnout Kazemier<br>
      Licensed under the MIT License.
    HTML

  end
end

module Docs
  class ReactRouter < UrlScraper
    self.name = 'React_Router'
    self.type = 'React_Router'
    self.version = '0.2.12'
    self.base_url = 'https://github.com/rackt/react-router/blob/master/'
    self.root_path = 'docs/README.md'

    html_filters.push 'react_router/entries', 'react_router/clean_html'

    options[:domain] = 'http://www.refly.xyz'
    options[:container] = 'article'
    options[:trailing_slash] = true
    options[:root_title] = 'React Router'
    options[:docset_uri] = '/react_router'

    options[:skip] = %w(CHANGELOG.md/)
    options[:attribution] = <<-HTML
      &copy; 2015 Rackt<br>
      Licensed under the MIT License.
    HTML

  end
end

module Docs
  class Lodash < UrlScraper
    self.name = 'Lo-Dash'
    self.slug = 'lodash'
    self.type = 'lodash'
    self.version = '2.4.1'
    self.base_url = 'https://lodash.com/docs'

    html_filters.push 'lodash/clean_html', 'lodash/entries', 'title'
    options[:domain] = 'http://www.refly.co'
    options[:root_title] = 'Lo-Dash'
    options[:docset_uri] = '/lodash'
    options[:title] = 'Lo-Dash'
    options[:container] = 'h1+div+div'
    options[:skip_links] = true

    options[:attribution] = <<-HTML
      &copy; 2012&ndash;2014 The Dojo Foundation<br>
      Licensed under the MIT License.
    HTML
  end
end

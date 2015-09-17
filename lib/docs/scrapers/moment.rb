module Docs
  class Moment < UrlScraper
    self.name = 'Moment.js'
    self.slug = 'moment'
    self.type = 'moment'
    self.version = '2.10.2'
    self.base_url = 'http://momentjs.com/docs/'

    html_filters.push 'moment/clean_html', 'moment/entries', 'title'

    options[:domain] = 'http://www.refly.xyz'
    options[:title] = 'Moment.js'
    options[:container] = '.docs-content'
    options[:skip_links] = true
    options[:root_title] = 'Moment'
    options[:docset_uri] = '/moment'


    options[:attribution] = <<-HTML
      &copy; 2011&ndash;2014 Tim Wood, Iskren Chernev, Moment.js contributors<br>
      Licensed under the MIT License.
    HTML
  end
end

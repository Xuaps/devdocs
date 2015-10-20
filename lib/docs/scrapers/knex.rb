module Docs
  class Knex < UrlScraper
    self.name = 'Knex'
    self.type = 'Knex'
    self.version = '0.8.6'
    self.base_url = 'http://knexjs.org/'
    html_filters.push 'knex/entries', 'knex/clean_html'

    options[:domain] = 'http://www.refly.xyz'
    options[:container] = '.container'
    options[:root_title] = 'Knex'
    options[:docset_uri] = '/knex'
    options[:attribution] = <<-HTML
      &copy; 2013&ndash;2014 Facebook Inc.<br>
      Licensed under BSD License.
    HTML
  end
end

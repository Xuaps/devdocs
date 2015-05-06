module Docs
  class Redis < UrlScraper
    self.type = 'redis'
    self.version = 'up to 2.8.18'
    self.base_url = 'http://redis.io/commands'

    html_filters.push 'redis/entries', 'redis/clean_html', 'title'

    options[:domain] = 'http://www.refly.co'
    options[:container] = ->(filter) { filter.root_page? ? '#commands' : '.text' }
    options[:title] = false
    options[:root_title] = 'Redis'
    options[:docset_uri] = '/redis'

    options[:follow_links] = ->(filter) { filter.root_page? }

    options[:attribution] = <<-HTML
      &copy; 2009&ndash;2014 Salvatore Sanfilippo<br>
      Licensed under the Creative Commons Attribution-ShareAlike License 4.0.
    HTML
  end
end

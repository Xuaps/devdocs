module Docs
  class Nokogiri2 < UrlScraper
    self.name = 'Nokogiri'
    self.slug = 'nokogiri'
    self.version = '1.6.4'
    self.base_url =  'http://www.rubydoc.info/gems/nokogiri/1.6.4/'
    self.root_path = 'index'
    self.initial_paths = %w(
      toplevel
    )
    html_filters.push 'nokogiri2/entries', 'nokogiri2/clean_html'

    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Nokogiri'
    options[:docset_uri] = '/nokogiri'
    options[:container] = '#content'

    options[:attribution] = <<-HTML
      &copy; 2008&ndash;2014 Aaron Patterson, Mike Dalessio, Charles Nutter,<br>
      Sergio Arbeo, Patrick Mahoney, Yoko Harada, Akinori Musha<br>
      Licensed under the MIT License.
    HTML
  end
end

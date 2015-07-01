module Docs
  class Maxcdn < UrlScraper
    self.name = 'MaxCDN'
    self.type = 'maxcdn'
    self.base_url = 'https://docs.maxcdn.com/'

    html_filters.push 'maxcdn/clean_html', 'maxcdn/entries'

    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'MaxCDN'
    options[:docset_uri] = '/maxcdn'
    options[:container] = '#readme-docs'
    options[:skip_links] = true

    options[:attribution] = <<-HTML
      &copy; 2014 MaxCDN<br>
      Licensed under the MIT License.
    HTML
  end
end

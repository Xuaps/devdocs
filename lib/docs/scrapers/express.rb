module Docs
  class Express < UrlScraper
    self.name = 'Express'
    self.type = 'express'
    self.version = '4.13.0'
    self.base_url = 'http://expressjs.com/4x/api.html'

    html_filters.push 'express/clean_html', 'express/entries', 'title'

    options[:domain] = 'http://www.refly.xyz'
    options[:title] = 'Express'
    options[:root_title] = 'Express'
    options[:docset_uri] = '/express'
    options[:container] = '#api-doc'
    options[:skip_links] = true

    options[:attribution] = <<-HTML
      &copy; 2009&ndash;2014 TJ Holowaychuk<br>
      Licensed under the MIT License.
    HTML
  end
end

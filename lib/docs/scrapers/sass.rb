module Docs
  class Sass < UrlScraper
    self.type = 'yard'
    self.version = '3.4.7'
    self.base_url = 'http://sass-lang.com/documentation/'
    self.root_path = 'file.SASS_REFERENCE.html'

    html_filters.push 'sass/clean_html', 'sass/entries', 'title'

    options[:domain] = 'http://www.refly.xyz'
    options[:only] = %w(Sass/Script/Functions.html)
    options[:root_title] = 'Sass'
    options[:title] = 'Sass Functions'
    options[:docset_uri] = '/sass'

    options[:container] = ->(filter) do
      filter.root_page? ? '#filecontents' : '#content'
    end

    options[:attribution] = <<-HTML
      &copy; 2006&ndash;2014 Hampton Catlin, Nathan Weizenbaum, and Chris Eppstein<br>
      Licensed under the MIT License.
    HTML
  end
end

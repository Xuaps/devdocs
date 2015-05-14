module Docs
  class Rails < UrlScraper
    self.name = 'Ruby on Rails'
    self.slug = 'rails'
    self.version = '4.2.0'
    self.base_url =  'http://www.rubydoc.info/docs/rails/'
    self.root_path = 'index'

    html_filters.push 'rails/entries', 'rails/clean_html'

    options[:domain] = 'http://www.refly.co'
    options[:root_title] = 'Rails'
    options[:docset_uri] = '/rails'
    options[:container] = '#content'

    options[:skip] = %w()

    options[:skip_patterns] = []

    options[:attribution] = <<-HTML
      &copy; 2004&ndash;2014 David Heinemeier Hansson<br>
      Licensed under the MIT License.
    HTML
  end
end

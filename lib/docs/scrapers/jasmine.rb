module Docs
  class Jasmine < UrlScraper
    self.name = 'jasmine'
    self.type = 'jasmine'
    self.version = 'edge'
    self.base_url = 'http://jasmine.github.io/edge/'
    self.root_path = 'introduction.html'

    html_filters.push 'jasmine/clean_html', 'jasmine/entries'

    options[:domain] = 'http://www.refly.xyz'
    options[:container] = '#container'
    options[:root_title] = 'Jasmine'
    options[:docset_uri] = '/jasmine'

    # options[:skip] = %w()
    # options[:skip_patterns] = [/bin/]
    options[:attribution] = <<-HTML
      &copy; 2015 Joyent, Inc. and other Node contributors<br>
      Licensed under the MIT License.
    HTML

  end
end

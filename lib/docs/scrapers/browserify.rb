module Docs
  class Browserify < UrlScraper
    self.name = 'Browserify'
    self.type = 'Browserify'
    self.version = '11.0.1'
    self.base_url = 'https://github.com/substack/node-browserify/blob/master/'
    self.root_path = 'readme.markdown'

    html_filters.push 'browserify/entries', 'browserify/clean_html'

    options[:domain] = 'http://www.refly.xyz'
    options[:container] = 'article'
    options[:trailing_slash] = true
    options[:root_title] = 'Browserify'
    options[:docset_uri] = '/browserify'

    options[:skip] = %w(changelog.markdown/)
    options[:skip_patterns] = [/bin/]
    options[:attribution] = <<-HTML
      &copy; 2015 Joyent, Inc. and other Node contributors<br>
      Licensed under the MIT License.
    HTML

  end
end

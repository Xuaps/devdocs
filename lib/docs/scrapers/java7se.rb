module Docs
  class Java7se < UrlScraper
    self.name = 'Java7SE'
    self.type = 'java7se'
    self.version = '7 SE'
    self.base_url = 'http://docs.oracle.com/javase/7/docs/api/'
    self.root_path = 'index-files/index-1.html'
    self.initial_paths = %w(
      allclasses-noframe.html)

    html_filters.push 'java7se/entries', 'java7se/clean_html'

    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Java 7 SE'
    options[:docset_uri] = '/java7se'
    options[:skip] = %w()
    options[:skip_patterns] = [
      /index\.html\.*/i,
      /index-files*/i
      ]
    options[:attribution] = <<-HTML
      &copy; 2015 Oracle Corporation<br>
      Licensed under the Oracle Binary Code License.
    HTML

  end
end

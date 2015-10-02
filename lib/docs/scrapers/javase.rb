module Docs
  class Javase < UrlScraper
    self.name = 'JavaSE'
    self.type = 'java'
    self.version = '7 SE'
    self.base_url = 'http://docs.oracle.com/javase/7/docs/api/'
    self.root_path = 'index-files/index-1.html'
    self.initial_paths = %w(
      allclasses-noframe.html)

    html_filters.push 'javase/clean_html', 'javase/entries'

    options[:domain] = 'http://www.refly.xyz'
    # options[:container] = ''
    options[:root_title] = 'JavaSE'
    options[:docset_uri] = '/javase'
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

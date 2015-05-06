module Docs
  class Nginx < UrlScraper
    self.name = 'nginx'
    self.type = 'nginx'
    self.version = '1.7.9'
    self.base_url = 'http://nginx.org/en/docs/'
    self.root_path = 'index.html'
    self.initial_paths = %w(
      varindex.html
      dirindex.html
    )


    html_filters.push 'nginx/clean_html', 'nginx/entries'

    options[:domain] = 'http://www.refly.co'
    options[:container] = '#content'
    options[:root_title] = 'Nginx'
    options[:docset_uri] = '/nginx'
    options[:skip] = %w(
      contributing_changes.html
      dirindex.html)

    options[:skip_patterns] = [/\/faq\//]

    options[:attribution] = <<-HTML
      &copy; 2002-2014 Igor Sysoev<br>
      &copy; 2011-2014 Nginx, Inc.<br>
      Licensed under the BSD License.
    HTML
  end
end

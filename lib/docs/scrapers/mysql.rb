module Docs
  class Mysql < UrlScraper
    self.name = 'Mysql'
    self.type = 'mysql'
    self.version = '5.7'
    self.base_url = 'http://dev.mysql.com/doc/refman/5.7/en/'
    self.root_path = 'index.html'
    html_filters.push 'mysql/entries', 'mysql/clean_html'

    options[:domain] = 'http://www.refly.xyz'
    options[:container] = '#page'
    options[:root_title] = 'Mysql'
    options[:docset_uri] = '/mysql'
    # options[:skip] = %w(
    # preface.html)
    options[:attribution] = <<-HTML
      &copy; 2015 Oracle Corporation<br>
      Licensed under the GPL License.
    HTML

  end
end

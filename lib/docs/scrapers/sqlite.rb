module Docs
  class Sqlite < FileScraper
    self.type = 'sqlite'
    self.version = '3.9.1'
    self.dir = 'file_scraper_docs/sqlite/sqlite-doc-3090100'
    self.base_url = "https://www.sqlite.org/"
    self.root_path = 'docs.html'
    self.initial_paths = %w(
      /c3ref/
      /syntax/
    )

    html_filters.push 'sqlite/clean_html', 'sqlite/entries'
    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'SQLite'
    options[:follow_links] = false
    options[:docset_uri] = '/sqlite'
    options[:only_patterns] = [
      /\A\w*\.html\Z/
    ]
     options[:skip_patterns] = [
      /\A\/matrix\/.*l\Z/,
      /\A\/releaselog\/.*l\Z/,
      /\A\/session\/.*l\Z/
    ]
    options[:skip] = %w(
      about.html
      sitemap.html
      download.html
      copyright.html
      news.html
      support.html
      index.html
      hp1.html
      oldnews.html
    )
    options[:attribution] = <<-HTML
      Without &copy;<br>
      SQLite is Public domain.
    HTML
  end
end

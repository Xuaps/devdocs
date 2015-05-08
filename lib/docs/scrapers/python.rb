module Docs
  class Python < FileScraper
    self.version = '3.4.2'
    self.type = 'sphinx'
    self.dir = './file_scraper_docs/python3/docs' # downloaded from docs.python.org/3/download.html
    self.base_url = 'http://docs.python.org/3/'
    self.root_path = 'library/index.html'

    html_filters.push 'python/entries', 'python/clean_html'

    options[:domain] = 'http://www.refly.co'
    options[:root_title] = 'Python3'
    options[:docset_uri] = '/python3'

    options[:only_patterns] = [/\Alibrary\//]

    options[:skip] = %w(
      library/2to3.html
      library/formatter.html
      library/index.html
      library/intro.html
      library/undoc.html
      library/unittest.mock-examples.html
      library/sunau.html)

    options[:attribution] = <<-HTML
      &copy; 1990&ndash;2014 Python Software Foundation<br>
      Licensed under the PSF License.
    HTML
  end
end

module Docs
  class Python2 < FileScraper
    self.name = 'Python 2'
    self.slug = 'python2'
    self.version = '2.7.10'
    self.type = 'sphinx'
    self.dir = './file_scraper_docs/python2/python-2.7.8-docs-html' # downloaded from docs.python.org/2.7/download.html
    self.base_url = 'http://docs.python.org/2.7/'
    self.root_path = 'library/index.html'

    html_filters.push 'python2/entries', 'python/clean_html'

    options[:domain] = 'http://www.refly.co'
    options[:root_title] = 'Python2'
    options[:docset_uri] = '/python2'

    options[:only_patterns] = [/\Alibrary\//]

    options[:skip] = %w(
      library/2to3.html
      library/formatter.html
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

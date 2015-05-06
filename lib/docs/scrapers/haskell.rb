module Docs
  class Haskell < UrlScraper
    self.name = 'Haskell'
    self.type = 'haskell'
    self.version = '7.8.2'
    self.base_url = 'https://downloads.haskell.org/~ghc/7.8.2/docs/html/libraries/'
    self.root_path = 'index.html'

    html_filters.push 'haskell/entries', 'haskell/clean_html'

    options[:domain] = 'http://www.refly.co'
    options[:container] = '#content'
    options[:root_title] = 'Haskell'
    options[:docset_uri] = '/haskell'

    options[:skip_patterns] = [/src\//, /doc-index/, /haskell2010/, /ghc-/, /Cabal-/]

    options[:attribution] = <<-HTML
      &copy; The University of Glasgow and others<br>
      Licensed under a BSD-style license (see top of the page).
    HTML
  end
end

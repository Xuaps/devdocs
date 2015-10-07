module Docs
  class Swift < UrlScraper
    self.type = 'swift'
    self.version = '12.4'
    self.base_url = 'https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/'
    self.root_path = 'TheBasics.html'
    self.initial_paths = %w(
      AboutTheLanguageReference.html
      )

    html_filters.push 'swift/clean_html', 'swift/entries'

    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Swift'
    options[:docset_uri] = '/swift'
    options[:container] = '.chapter'
    options[:skip] = [
      'RevisionHistory.html',
      'GuidedTour.playground.zip',
      'GuidedTour.html'
      ]

    options[:attribution] = <<-HTML
      &copy; 2015 Apple Inc.<br>
      Licensed under Open Source.
    HTML

  end
end

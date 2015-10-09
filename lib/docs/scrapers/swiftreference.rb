module Docs
  class Swiftreference < UrlScraper
    self.type = 'Swiftreference'
    self.version = '1.0'
    self.base_url = 'https://developer.apple.com/library/watchos/documentation/Swift/Reference'
    self.root_path = 'Swift_Int_Structure/index.html'

    html_filters.push 'swiftreference/clean_html', 'swiftreference/entries'

    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Swift'
    options[:docset_uri] = '/swift/reference'
    options[:container] = 'article'
    options[:skip_patterns] = [
    /.*RevisionHistory.html.*/
    ]

    options[:attribution] = <<-HTML
      &copy; 2015 Apple Inc.<br>
      Licensed under Open Source.
    HTML

  end
end

module Docs
  class Angular < UrlScraper

    self.name = 'AngularJS'
    self.slug = 'angular'
    self.type = 'angular'
    self.version = '1.4.5'
    self.base_url = "https://code.angularjs.org/#{version}/docs/partials/api/"

    html_filters.push 'angular/entries', 'angular/clean_html', 'title'
    text_filters.push 'angular/clean_urls'

    options[:title] = false
    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'AngularJS'
    options[:docset_uri] = '/angularjs'
    options[:skip_patterns] = [
      /\/misc\/misc\/.*/,
    ]

    options[:attribution] = <<-HTML
      &copy; 2010&ndash;2015 Google, Inc.<br>
      Licensed under the Creative Commons Attribution License 3.0.
    HTML


  end
end
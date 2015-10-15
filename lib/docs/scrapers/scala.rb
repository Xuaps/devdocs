module Docs
  class Scala < UrlScraper
    self.type = 'scala'
    self.version = '2.11'
    self.base_url = "http://www.scala-lang.org/api/current/scala/"

    html_filters.push 'scala/entries', 'scala/clean_html'
    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Scala'
    options[:docset_uri] = '/scala'
    options[:skip] = %w(
      package.html
    )
    options[:skip_patterns] = [/.*\?.*/]
    options[:fix_urls] = ->(url) do
      url.sub! '%24%24', '$$'
      url.sub! '%24', '$'
      url
    end
    options[:attribution] = <<-HTML
      &copy; 2003-2013 EPFL<br>
      All rights reserved.
    HTML
  end
end

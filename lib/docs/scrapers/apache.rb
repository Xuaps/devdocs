module Docs
  class Apache < UrlScraper
    self.name = 'Apache HTTP Server'
    self.slug = 'apache'
    self.type = 'apache'
    self.version = '2.4.12'
    self.base_url = 'http://httpd.apache.org/docs/2.4/en/'

    html_filters.push 'apache/clean_html', 'apache/entries'
    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Apache'
    options[:docset_uri] = '/apache'
    options[:container] = '#page-content'

    options[:skip] = %w(
      upgrading.html
      license.html
      sitemap.html
      glossary.html
      mod/quickreference.html
      mod/directive-dict.html
      mod/directives.html
      mod/module-dict.html
      programs/other.html)

    options[:skip_patterns] = [
      /\A(da|de|en|es|fr|ja|ko|pt-br|tr|zh-cn)\//,
      /\Anew_features/,
      /\Adeveloper\// ]

    options[:attribution] = <<-HTML
      &copy; The Apache Software Foundation<br>
      Licensed under the Apache License, Version 2.0.
    HTML
  end
end
module Docs
  class Npm < UrlScraper
    self.name = 'npm'
    self.type = 'npm'
    self.version = '2.13.0'
    self.base_url = 'https://docs.npmjs.com/'

    html_filters.push 'npm/entries', 'npm/clean_html', 'title'

    options[:container] = ->(filter) { filter.root_page? ? '.toc' : nil }
    options[:title] = false
    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'npm'
    options[:docset_uri] = '/npm'
    options[:skip] = %w(all)
    options[:skip_patterns] = [
      /\Aenterprise/,
      /\Acompany/,
      /\Apolicies/
    ]

    options[:attribution] = <<-HTML
      &copy; npm, Inc. and Contributors<br>
      Licensed under the npm License.<br>
      npm is a trademark of npm, Inc.
    HTML
  end
end
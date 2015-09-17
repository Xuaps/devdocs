module Docs
  class Node < UrlScraper
    self.name = 'Node.js'
    self.slug = 'node'
    self.type = 'node'
    self.version = '4.0.0'
    self.base_url = 'https://nodejs.org/api/'

    html_filters.push 'node/clean_html', 'node/entries', 'title'

    options[:domain] = 'http://www.refly.xyz'
    options[:title] = false
    options[:root_title] = 'NodeJS'
    options[:docset_uri] = '/nodejs'
    options[:container] = '#apicontent'
    options[:skip] = %w(all.html)

    options[:attribution] = <<-HTML
      &copy; Joyent, Inc. and other Node contributors<br>
      Licensed under the MIT License.
    HTML
  end
end

module Docs
  class Http < UrlScraper
    self.name = 'HTTP'
    self.type = 'rfc'
    self.base_url = 'https://tools.ietf.org/html/'
    self.initial_paths = %w(rfc2616 rfc7230 rfc7231
      rfc7232 rfc7233 rfc7234 rfc7235)

    html_filters.push 'http/clean_html', 'http/entries'
    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Http'
    options[:docset_uri] = '/http'
    options[:skip_links] = true
    options[:attribution] = <<-HTML
      &copy; document authors. All rights reserved.
    HTML
  end
end

module Docs
  class Relay < React
    self.type = 'react'
    self.version = '0.5'
    self.base_url = 'https://facebook.github.io/relay/docs/'
    self.root_path = 'getting-started.html'
    self.links = {
      home: 'https://facebook.github.io/relay/',
      code: 'https://github.com/facebook/relay'
    }

    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Relay'
    options[:docset_uri] = '/relay'
    options[:only_patterns] = nil
    options[:skip] = %w(videos.html graphql-further-reading.html)

    options[:attribution] = <<-HTML
      &copy; 2013&ndash;2015 Facebook Inc.<br>
      Licensed under the BSD License.
    HTML
  end
end

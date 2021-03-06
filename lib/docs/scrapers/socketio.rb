module Docs
  class Socketio < UrlScraper
    self.name = 'Socket.IO'
    self.slug = 'socketio'
    self.type = 'socketio'
    self.version = '1.3.6'
    self.base_url = 'http://socket.io/docs/'

    html_filters.push 'socketio/clean_html', 'socketio/entries'

    options[:domain] = 'http://www.refly.xyz'
    options[:container] = '#content'
    options[:root_title] = 'SocketIO'
    options[:docset_uri] = '/socketio'
    options[:trailing_slash] = false
    options[:skip] = %w(faq)

    options[:attribution] = <<-HTML
      &copy; 2014 Automattic<br>
      Licensed under the MIT License.
    HTML
  end
end

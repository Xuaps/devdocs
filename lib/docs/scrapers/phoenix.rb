module Docs
  class Phoenix < Elixir
    self.type = 'elixir'
    self.version = '1.0.3'
    self.base_url = 'http://hexdocs.pm/'
    self.root_path = 'phoenix/Phoenix.html'
    self.initial_paths = %w(
      phoenix/extra-api-reference.html
      ecto/extra-api-reference.html
      phoenix_html/extra-api-reference.html
      plug/extra-api-reference.html)
    self.links = {
      home: 'http://www.phoenixframework.org',
      code: 'https://github.com/phoenixframework/phoenix'
    }

    options[:root_title] = false
    options[:root_title] = 'Phoenix'
    options[:domain] = 'http://www.refly.xyz'
    options[:docset_uri] = '/phoenix'
    options[:skip_patterns] = [/extra-api-reference/]
    options[:only_patterns] = [
      /\Aphoenix\//,
      /\Aecto\//,
      /\Aphoenix_html\//,
      /\Aplug\//
    ]

    options[:attribution] = -> (filter) {
      if filter.slug.start_with?('ecto')
        <<-HTML
          &copy; 2012 Plataformatec<br>
          Licensed under the Apache License, Version 2.0.
        HTML
      elsif filter.slug.start_with?('plug')
        <<-HTML
          &copy; 2013 Plataformatec<br>
          Licensed under the Apache License, Version 2.0.
        HTML
      else
        <<-HTML
          &copy; 2014 Chris McCord<br>
          Licensed under the MIT License.
        HTML
      end
    }
  end
end

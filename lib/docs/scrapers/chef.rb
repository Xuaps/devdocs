module Docs
  class Chef < UrlScraper
    self.type = 'chef'
    self.version = '12.4'
    self.base_url = 'https://docs.chef.io/'
    self.root_path = 'index.html'
    self.initial_paths = %w(
      resources.html
      )

    html_filters.push 'chef/clean_html', 'chef/entries'

    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Chef'
    options[:docset_uri] = '/chef'
    options[:container] = '.body'
    options[:skip_patterns] = [/\Adecks\//, /.*\.svg/]
    options[:skip] = %w(
      lwrp.html
      signup
      )

    options[:attribution] = <<-HTML
      &copy; 2015 The Chef Project Developers<br>
      Licensed under the Creative Common, Version 3.0.
    HTML

  end
end

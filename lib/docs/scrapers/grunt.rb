module Docs
  class Grunt < UrlScraper
    self.name = 'Grunt'
    self.type = 'grunt'
    self.version = '0.4.5'
    self.base_url = 'http://gruntjs.com/'
    self.initial_paths = %w(api/grunt getting-started)

    html_filters.push 'grunt/clean_html', 'grunt/entries'

    options[:only] = %w(
      getting-started
      configuring-tasks
      sample-gruntfile
      creating-tasks
      using-the-cli
    )
    options[:domain] = 'http://www.refly.co'
    options[:only_patterns] = [/\Aapi\//]
    options[:root_title] = 'Grunt'
    options[:docset_uri] = '/grunt'
    options[:container] = '.container > .row-fluid'

    options[:attribution] = <<-HTML
      &copy; 2014 Grunt Team<br>
      Licensed under the MIT License.
    HTML

    
  end

end

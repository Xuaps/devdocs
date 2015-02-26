module Docs
  class Less < UrlScraper
    self.type = 'less'
    self.version = '2.1.0'
    self.base_url = 'http://lesscss.org'
    self.root_path = '/features'
    self.initial_paths = %w(/functions)

    html_filters.push 'less/clean_html', 'less/entries', 'title'

    options[:title] = 'Less'
    options[:root_title] = 'Less'
    options[:docset_uri] = '/less'
    options[:container] = 'div[role=main]'
    options[:follow_links] = false
    options[:trailing_slash] = false

    options[:attribution] = <<-HTML
      &copy; 2009&ndash;2014 The Core Less Team<br>
      Licensed under the Creative Commons Attribution License 3.0.
    HTML
  end
end

module Docs
  class Cpp < FileScraper
    self.name = 'C++'
    self.slug = 'cpp'
    self.type = 'c'
    self.dir = './file_scraper_docs/c/reference/en/cpp'
    self.base_url = 'http://en.cppreference.com/w/cpp/'
    self.root_path = 'header.html'
    self.initial_paths = %w(
      /experimental.html
    )
    html_filters.insert_before 'clean_html', 'c/fix_code'
    html_filters.push 'cpp/entries', 'c/clean_html', 'title'
    text_filters.push 'cpp/fix_urls'

    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Cpp'
    options[:docset_uri] = '/cpp'
    options[:container] = '#content'
    options[:title] = false
    options[:skip] = %w(
      language/extending_std.html
      language/history.html
      regex/ecmascript.html
      regex/regex_token_iterator/operator_cmp.html

    )
    options[:only_patterns] = [/\.html\z/]

    options[:fix_urls] = ->(url) do
      url.sub! %r{\A.+/http%3A/}, "http://"
      url
    end

    options[:attribution] = <<-HTML
      &copy; cppreference.com<br>
      Licensed under the Creative Commons Attribution-ShareAlike Unported License v3.0.
    HTML
  end
end
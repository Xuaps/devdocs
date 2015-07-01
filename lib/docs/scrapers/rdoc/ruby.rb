module Docs
  class Ruby < UrlScraper
    self.name = 'Ruby'
    self.type = 'Ruby'
    self.version = '2.2.2'
    self.base_url =  'http://ruby-doc.org/stdlib-2.2.2/'
    self.root_path = 'toc.html'

    html_filters.push 'ruby/clean_html', 'ruby/entries'
    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Ruby'
    options[:docset_uri] = '/ruby'

    options[:skip] = %w(
      contributing_rdoc.html
      contributors_rdoc.html
      dtrace_probes_rdoc.html
      maintainers_rdoc.html
      regexp_rdoc.html
      standard_library_rdoc.html
      syntax_rdoc.html
      Data.html
      English.html
      Fcntl.html
      Kconv.html
      NKF.html
      OLEProperty.html
      OptParse.html
      UnicodeNormalize.html)

    options[:skip_patterns] = []

    options[:attribution] = <<-HTML
      Ruby Core &copy; 1993&ndash;2015 Yukihiro Matsumoto<br>
      Licensed under the Ruby License.<br>
      Ruby Standard Library &copy; contributors<br>
      Licensed under their own licenses.
    HTML
  end
end
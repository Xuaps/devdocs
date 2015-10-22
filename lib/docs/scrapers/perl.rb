module Docs
  class Perl < FileScraper
    self.version = '5.22'
    self.type = 'sphinx'
    self.dir = './file_scraper_docs/perl/perldoc-html' # downloaded from docs.python.org/3/download.html
    self.base_url = 'http://perldoc.perl.org/'
    self.root_path = 'index.html'
    self.initial_paths = %w(
      index-language.html
      index-overview.html
      index-tutorials.html
      index-faq.html
      index-language.html
      index-functions.html
      index-operators.html
      perlvar.html
      index-pragmas.html
      index-utilities.html
      index-platforms.html
      index-internals.html
      )

    html_filters.push 'perl/entries', 'perl/clean_html'

    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Perl'
    options[:docset_uri] = '/perl'
    options[:container] = '#content_body'
    options[:skip_patterns] = [
      /perl\d*delta\.html/,
      /index-modules-\w\.html/
    ]
    options[:attribution] = <<-HTML
      &copy; 1989&ndash; Free Software Foundation, Inc.<br>
      Licensed under the GNU General Public License.
    HTML
  end
end

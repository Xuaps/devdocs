module Docs
  class Django < FileScraper
    self.name = 'Django'
    self.type = 'sphinx'
    self.version = '1.8.4'
    self.dir = './file_scraper_docs/django'
    self.base_url = 'https://docs.djangoproject.com/en/1.8/'
    self.root_path = 'index.html'

    html_filters.push 'django/entries', 'django/clean_html'
    text_filters.push 'django/fix_urls'

    options[:domain] = 'http://www.refly.xyz'
    options[:title] = false
    options[:root_title] = 'Django'
    options[:docset_uri] = '/django'
    options[:container] = '#bd'

    # options[:skip] = %w(
    #   contents.html
    #   genindex.html
    #   py-modindex.html
    #   glossary.html
    #   search.html
    #   intro/whatsnext.html)

    options[:skip_patterns] = [
      /\Afaq\//,
      /\Ainternals\//,
      /\Amisc\//,
      /\Areleases\//,
      /\A_/,
      /flattened\-index\.html/]

    options[:attribution] = <<-HTML
      &copy; Django Software Foundation and individual contributors<br>
      Licensed under the BSD License.
    HTML
  end
end

module Docs
  class Markdown < UrlScraper
    self.name = 'Markdown'
    self.type = 'markdown'
    self.base_url = 'http://daringfireball.net/projects/markdown/syntax'

    html_filters.push 'markdown/clean_html', 'markdown/entries'

    options[:domain] = 'http://www.refly.xyz'
    options[:container] = '.article'
    options[:skip_links] = true
    options[:root_title] = 'MarkDown'
    options[:docset_uri] = '/markdown'

    options[:attribution] = <<-HTML
      &copy; 2004 John Gruber<br>
      Licensed under the BSD License.
    HTML
  end
end

module Docs
  class Git < UrlScraper
    self.type = 'git'
    self.version = '2.5.1'
    self.base_url = 'http://git-scm.com/docs'
    self.initial_paths = %w(
      /git.html
      /git-upload-archive
      /git-annotate
      /git-blame
      /gitcli
      /line-range-format.txt
      /giteveryday
      /gittutorial
      /gittutorial-2
      /user-manual
      /gitcore-tutorial
      /gitglossary
      /gitcvs-migration
      /gitattributes
      /gitworkflows
      /gitignore
    )

    html_filters.push 'git/clean_html', 'git/entries'
    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Git'
    options[:title] = false
    options[:docset_uri] = '/git'
    options[:container] = ->(filter) { filter.root_page? ? '#main' : '.man-page, #main' }
    #options[:follow_links] = ->(filter) { filter.root_page? }

    options[:attribution] = <<-HTML
      &copy; 2005&ndash;2014 Linus Torvalds and others<br>
      Licensed under the GNU General Public License version 2.
    HTML
  end
end

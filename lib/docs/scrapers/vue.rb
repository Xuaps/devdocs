module Docs
  class Vue < UrlScraper
    self.name = 'Vue.js'
    self.slug = 'vue'
    self.type = 'vue'
    self.version = '0.12.9'
    self.base_url = 'http://vuejs.org'
    self.root_path = '/guide/index.html'
    self.initial_paths = %w(/api/index.html)

    html_filters.push 'vue/clean_html', 'vue/entries'

    options[:only_patterns] = [/\/guide\//, /\/api\//]
    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Vue'
    options[:docset_uri] = '/vue'
    options[:attribution] = <<-HTML
      &copy; 2013&ndash;2015 Evan You, Vue.js contributors<br>
      Licensed under the MIT License.
    HTML
  end
end

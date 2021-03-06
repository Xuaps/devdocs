module Docs
  class Yii < UrlScraper
    self.type = 'yii'
    self.version = '2.0.2'
    self.base_url = 'http://www.yiiframework.com/doc-2.0/'
    self.root_path = 'index.html'

    html_filters.push 'yii/clean_html', 'yii/entries'

    options[:domain] = 'http://www.refly.xyz'
    options[:container] = 'div[role=main]'
    options[:root_title] = 'Yii'
    options[:docset_uri] = '/yii'
    options[:skip_patterns] = [/\Ayii-apidoc/]

    options[:attribution] = <<-HTML
      &copy; 2008&ndash;2014 by Yii Software LLC<br>
      Licensed under the three clause BSD license.
    HTML
  end
end

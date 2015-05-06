module Docs
  class Mongoose < UrlScraper
    self.name = 'MongooseJS'
    self.type = 'mongoose'
    self.version = '3.8.19'
    self.base_url = 'http://mongoosejs.com/docs/'
    self.root_path = 'index.html'
    self.initial_paths = %w(guide.html api.html)

    html_filters.push 'mongoose/clean_html', 'mongoose/entries'

    options[:domain] = 'http://www.refly.co'
    options[:container] = '#content'
    options[:root_title] = 'MongooseJS'
    options[:docset_uri] = '/mongoosejs'
    options[:skip] = %w(
      faq.html
      prior.html
      migration.html
      plugins)

    options[:attribution] = <<-HTML
      &copy; 2010 LearnBoost<br>
      Licensed under the MIT License.
    HTML
  end
end

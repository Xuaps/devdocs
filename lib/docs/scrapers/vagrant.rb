module Docs
  class Vagrant < UrlScraper
    self.name = 'Vagrant'
    self.type = 'vagrant'
    self.release = '1.8.3'
    self.base_url = 'https://www.vagrantup.com/docs/'
    self.root_path = 'index.html'
    self.links = {
      home: 'https://www.vagrantup.com/',
      code: 'https://github.com/mitchellh/vagrant'
    }

    html_filters.push 'vagrant/entries', 'vagrant/clean_html'
    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Vagrant'
    options[:docset_uri] = '/vagrant'

    options[:attribution] = <<-HTML
      &copy; 2010&ndash;2016 Mitchell Hashimoto<br>
      Licensed under the MIT License.
    HTML
  end
end

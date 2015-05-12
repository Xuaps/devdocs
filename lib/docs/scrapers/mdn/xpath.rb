module Docs
  class Xpath < Mdn
    self.name = 'XPath'
    self.base_url = 'https://developer.mozilla.org/en-US/docs/Web/XPath'
    self.root_path = '/index'

    html_filters.push 'xpath/entries', 'xpath/clean_html', 'title'

    options[:root_title] = 'XPath'
    options[:docset_uri] = '/xpath'
    options[:skip_patterns] = [/\w*\$\w+/i]
    


    options[:fix_urls] = ->(url) do
      url.sub! 'https://developer.mozilla.org/en/XPath', Xpath.base_url
      url.sub! 'https://developer.mozilla.org/en-US/docs/XPath', Xpath.base_url
      url
    end
  end
end

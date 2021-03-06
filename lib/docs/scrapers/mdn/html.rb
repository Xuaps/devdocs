module Docs
  class Html < Mdn
    self.name = 'HTML'
    self.base_url = 'https://developer.mozilla.org/en-US/docs/Web/HTML'
    self.root_path = '/Element'
    self.initial_paths = %w(/Attributes /Link_types /element /Global_elements)

    html_filters.push  'html/entries', 'html/clean_html', 'title'

    options[:root_title] = 'HTML'
    options[:docset_uri] = '/html'

    options[:title] = false
    options[:skip_patterns] = [/\w*\$\w+/i]

    options[:fix_urls] = ->(url) do
      url.sub! %r{https://developer\.mozilla\.org/en\-US/docs/Web/HTML/([_a-z@:])},  "#{Javascript.base_url}/\\1"
      url.sub! 'https://developer.mozilla.org/en-US/docs/Web/HTML/Content_categories', 'https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Content_categories'
      url
    end
  end
end

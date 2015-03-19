module Docs
  class Html < Mdn
    self.name = 'HTML'
    self.base_url = 'https://developer.mozilla.org/en-US/docs/Web/HTML'
    self.root_path = '/Element'
    self.initial_paths = %w(/Attributes /Link_types /element /Global_elements)

    html_filters.push 'html/clean_html', 'html/entries', 'title'

    options[:root_title] = 'HTML'
    options[:docset_uri] = '/html'

    options[:title] = ->(filter) do
      if filter.slug == 'Element/Heading_Elements'
        'Heading Elements'
      elsif filter.slug == 'Attributes'
        'Attributes'
      elsif filter.slug == 'Link_types'
        'Link types'
      else
        "<#{filter.default_title}>"
      end
    end

    options[:replace_paths] = {
      '/Element/h1' => '/Element/Heading_Elements',
      '/Element/h2' => '/Element/Heading_Elements',
      '/Element/h3' => '/Element/Heading_Elements',
      '/Element/h4' => '/Element/Heading_Elements',
      '/Element/h5' => '/Element/Heading_Elements',
      '/Element/h6' => '/Element/Heading_Elements' }

    options[:fix_urls] = ->(url) do
      url.sub! %r{https://developer\.mozilla\.org/en\-US/docs/Web/HTML/([_a-z@:])},  "#{Javascript.base_url}/\\1"
      url.sub! 'https://developer.mozilla.org/en-US/docs/Web/HTML/Content_categories', 'https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Content_categories'
      url
    end
  end
end

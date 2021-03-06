module Docs
  class Svg < Mdn
    self.name = 'SVG'
    self.base_url = 'https://developer.mozilla.org/en-US/docs/Web/SVG'

    html_filters.push 'svg/entries', 'svg/clean_html', 'title'
    options[:root_title] = 'SVG'
    options[:docset_uri] = '/svg'
    options[:title] = ->(filter) do
      if filter.slug.starts_with?('Element/')
        "<#{filter.default_title}>"
      elsif filter.slug != 'Attribute' && filter.slug != 'Element'
        filter.default_title
      else
        false
      end
    end
    options[:skip_patterns] = [/\w*\$\w+/i]
    options[:skip] = %w(
      /Compatibility_sources
      /FAQ
      /SVG_animation_with_SMIL
      /SVG_as_an_Image)

    options[:fix_urls] = ->(url) do
      url.sub! 'https://developer.mozilla.org/en-US/Web/SVG', Svg.base_url
      url.sub! 'https://developer.mozilla.org/en-US/docs/SVG', Svg.base_url
      url.sub! 'https://developer.mozilla.org/en/SVG', Svg.base_url
      url
    end
  end
end

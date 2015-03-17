module Docs
  class Css < Mdn
    self.name = 'CSS'
    self.base_url = 'https://developer.mozilla.org/en-US/docs/Web/CSS'
    self.root_path = '/Reference'

    html_filters.push 'css/clean_html', 'css/entries'

    options[:root_title] = 'CSS'
    options[:docset_uri] = '/css'

    options[:skip] = %w(
      /Syntax
      /At-rule
      /Comments
      /Specificity
      /inheritance
      /specified_value
      /used_value actual_value
      /box_model
      /Replaced_element
      /Value_definition_syntax
      /Layout_mode
      /Visual_formatting_model
      /Shorthand_properties
      /margin_collapsing
      /CSS3
      /CSS_values_syntax
      /Media/Visual
      /block_formatting_context
      /image()
      /paged_media)

    options[:skip_patterns] = [/\-webkit/, /\-moz/, /Extensions/, /Tools/]

    options[:replace_paths] = {
      '/%3Cbasic-shape%3E' => '/basic-shape'
    }

    options[:fix_urls] = ->(url) do
      url.sub! %r{https://developer\.mozilla\.org/en\-US/docs/CSS/([a-z@:])}, "#{Css.base_url}/\\1"
      url
    end
  end
end

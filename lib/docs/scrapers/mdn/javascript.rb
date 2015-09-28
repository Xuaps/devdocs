module Docs
  class Javascript < Mdn
    self.name = 'JavaScript'
    self.base_url = 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference'

    html_filters.push 'javascript/entries', 'javascript/clean_html'

    options[:root_title] = 'JavaScript'

    options[:docset_uri] = '/javascript'

    options[:skip_patterns] = [/\w*\$\w+/i]
    # Don't want
    options[:skip] = %w(
      /About
      /Code_comments
      /Deprecated_Features
      /Functions_and_function_scope
      /Global_Objects/Iterator
      /Reserved_Words
      /arrow_functions
      /default_parameters
      /Strict_mode
      /Functions/rest_parameters
      /Methods_Index
      /Properties_Index
      /Strict_mode/Transitioning_to_strict_mode
      /Operators/Legacy_generator_function
      /Statements/Legacy_generator_function)
    # Duplicates 301
    options[:skip] = %w(
      /Global_Objects/object/__proto__
      /Global_Objects/object/__definegetter__
      /Global_Objects/object/__definesetter__
      /Global_Objects/object/__lookupgetter__
      /Global_Objects/function/constructor)
    options[:fix_urls] = ->(url) do
      url.sub! 'https://developer.mozilla.org/en-US/docs/JavaScript/Reference',  Javascript.base_url
      url.sub! 'https://developer.mozilla.org/en/JavaScript/Reference',          Javascript.base_url
      url.sub! 'https://developer.mozilla.org/en/Core_JavaScript_1.5_Reference', Javascript.base_url
      url.sub! 'https://developer.mozilla.org/En/Core_JavaScript_1.5_Reference', Javascript.base_url
      url.sub! '/Operators/Special/', '/Operators/'
      url.sub! '/Operators/Special/', '/Operators/'
      url.sub! '%40%40', '@@'

      url.sub! 'Functions_and_function_scope', 'Functions'
      url.sub! 'Array.prototype.values()', 'values'
      url
    end
  end
end

module Docs
  class JqueryMobile < Jquery
    self.name = 'jQuery Mobile'
    self.slug = 'jquerymobile'
    self.version = '1.4.0'
    self.base_url = 'http://api.jquerymobile.com'
    self.root_path = '/category/all'

    html_filters.insert_before 'jquery/clean_html', 'jquery_mobile/entries'

    options[:root_title] = 'JQuery Mobile'
    options[:docset_uri] = '/jquery-mobile'
    #options[:skip] = %w(/tabs /theme)
    options[:skip_patterns].concat [/\A\/icons/]
    options[:skip] = %w(/cdn-cgi/l/email-protection)
    options[:replace_paths] = { '/select/' => '/selectmenu' }
  end
end

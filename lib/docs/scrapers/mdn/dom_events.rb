module Docs
  class DomEvents < Mdn
    self.name = 'DOM Events'
    self.slug = 'dom_events'
    self.base_url = 'https://developer.mozilla.org/en-US/docs/Web/Events'

    html_filters.insert_after 'clean_html'
    html_filters.push 'dom_events/entries', 'dom_events/clean_html', 'title'
    self.initial_paths = %w(
      /Events)
    options[:skip_patterns] = [/\w*\$\w+/i]
    options[:root_title] = 'DOM Events'
    options[:docset_uri] = '/dom-events'
    options[:fix_urls] = ->(url) do
      url.sub! 'https://developer.mozilla.org/en-US/Mozilla_event_reference',      DomEvents.base_url
      url.sub! 'https://developer.mozilla.org/en-US/docs/Mozilla_event_reference', DomEvents.base_url
      url.sub! 'https://developer.mozilla.org/en-US/docs/Web/Reference/Events',    DomEvents.base_url
      url
    end
  end
end

module Docs
  class Knockout
    class EntriesFilter < Docs::EntriesFilter
      NAME_BY_SLUG = {
        'custom-bindings'                                 => 'Custom bindings',
        'custom-bindings-controlling-descendant-bindings' => 'Descendant bindings',
        'custom-bindings-for-virtual-elements'            => 'Virtual elements',
        'binding-preprocessing'                           => 'Binding preprocessing',
        'json-data'                                       => 'JSON data',
        'extenders'                                       => 'Extending observables',
        'unobtrusive-event-handling'                      => 'Event handling',
        'fn'                                              => 'Custom functions',
        'ratelimit-observable'                            => 'rateLimit extender' }

      def get_name
        return NAME_BY_SLUG[slug] if NAME_BY_SLUG.has_key?(slug)
        name = at_css('h1').content.strip
        name.remove! 'The '
        name.sub! %r{"(.+?)"}, '\1'
        name.gsub!(/ [A-Z]/) { |str| str.downcase! }
        name
      end

      def get_type
        name = get_name
        if name =~ /observable/i || slug =~ /extender/
          'object'
        elsif slug.include?('binding')
          'binding'
        elsif name.include? 'function'
          'function'
        elsif name.include? 'Event'
          'event'
        else
          'others'
        end
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name)
        end
        parsed_uri
      end

      def get_parent_uri
        'null'
      end                                         

    end
  end
end

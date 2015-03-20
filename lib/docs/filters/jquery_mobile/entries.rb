module Docs
  class JqueryMobile
    class EntriesFilter < Docs::EntriesFilter
      # Ordered by precedence
      TYPES = %w(Widgets Events Properties Methods)
      REPLACE_TYPES = {
        'Widgets'           => 'function',
        'Events'            => 'event',
        'Properties'        => 'property',
        'Methods'           => 'method'}

      def get_name
        name = at_css('h1').content.strip
        name.remove! ' Widget'
        name.prepend '.' if name.start_with? 'jqm'
        name << ' event' if type == 'Events' && !name.end_with?(' event')
        name
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
        subpath = *path.sub('/index', '').split('/')
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            parent_uri = 'null'
        end
      end

      def get_type
        categories = css 'span.category'
        types = categories.map { |node| node.at_css('a').content.strip }
        types.map! { |type| TYPES.index(type) }
        types.compact!
        types.sort!
        types.empty? ? 'others' : REPLACE_TYPES[TYPES[types.first]]
      end
    end
  end
end

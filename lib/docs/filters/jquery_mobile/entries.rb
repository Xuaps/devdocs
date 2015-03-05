module Docs
  class JqueryMobile
    class EntriesFilter < Docs::EntriesFilter
      # Ordered by precedence
      TYPES = %w(Widgets Events Properties Methods)

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
        parsed_uri = context[:docset_uri] + '/' + path.sub('/index', '')
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
        types.empty? ? 'others' : TYPES[types.first]
      end
    end
  end
end

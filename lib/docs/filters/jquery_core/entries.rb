module Docs
  class JqueryCore
    class EntriesFilter < Docs::EntriesFilter
      # Ordered by precedence
      TYPES = ['Ajax', 'Selectors', 'Callbacks Object', 'Deferred Object',
        'Data', 'Utilities', 'Events', 'Effects', 'Offset', 'Dimensions',
        'Traversing', 'Manipulation']
      REPLACE_TYPES = {
        'Traversing'        => 'function',
        'Effects'           => 'function',
        'Utilities'         => 'function',
        'Ajax'              => 'data',
        'Data'              => 'data',
        'Events'            => 'event',
        'Callbacks Object'  => 'object',
        'Deferred Object'   => 'object',
        'Selectors'         => 'selector',
        'Manipulation'      => 'method',
        'Offset'            => 'method',
        'Dimensions'        => 'property'}

      def get_name
        name = at_css('h1').content.strip
        name.gsub!(/ [A-Z]/) { |str| str.downcase! }
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
        return 'data' if slug == 'Ajax_Events'
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

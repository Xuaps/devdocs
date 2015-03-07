module Docs
  class JqueryUi
    class EntriesFilter < Docs::EntriesFilter
      # Ordered by precedence
      TYPES = ['Widgets', 'Selectors', 'Effects', 'Interactions', 'Methods']
      REPLACE_TYPES = {
        'Widgets'           => 'function',
        'Selectors'         => 'selector',
        'Effects'           => 'function',
        'Interactions'      => 'method',
        'Methods'           => 'method'}

      def get_name
        name = at_css('h1').content.strip
        name.remove! ' Widget'
        name.gsub!(/ [A-Z]/) { |str| str.downcase! }
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
        types.empty? ? 'others' : REPLACE_TYPES[TYPES[types.first]]
      end
    end
  end
end

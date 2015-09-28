module Docs
  class JqueryUi
    class EntriesFilter < Docs::ReflyEntriesFilter
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

      def get_parsed_uri_by_name(name)
          get_parsed_uri + '/' + self.urilized(name)
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
        categories = css 'span.category > a'
        types = categories.map { |node| node.content.strip }
        types.map! { |type| TYPES.index(type) }
        types.compact!
        types.sort!
        types.empty? ? 'others' : REPLACE_TYPES[TYPES[types.first]]
      end

      def additional_entries
        entries = []
        return [] if root_page?
        css('[id].api-item > h3').each do |node|
          node.at_css('.returns').remove if node.at_css('.returns')
          name = node.content
          id = node.parent['id']
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, id, get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end
        entries
      end

    end
  end
end

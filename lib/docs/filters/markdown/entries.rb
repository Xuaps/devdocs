module Docs
  class Markdown
    class EntriesFilter < Docs::EntriesFilter
      REPLACE_TYPES = {
        'Philosophy' => 'guide',
        'Inline HTML' => 'guide',
        'Automatic Escaping for Special Characters' => 'guide',
        'Paragraphs and Line Breaks' => 'element',
        'Headers' => 'element',
        'Blockquotes' => 'element',
        'Lists' => 'element',
        'Code Blocks' => 'element',
        'Horizontal Rules' => 'element',
        'Links' => 'element',
        'Emphasis' => 'element',
        'Code' => 'element',
        'Images' => 'element',
        'Automatic Links' => 'others',
        'Backslash Escapes' => 'others'
      }
      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_name
        name = 'Markdown'
        name
      end

      def get_parsed_uri_by_name(name)
          context[:docset_uri] + '/' + self.urilized(name)
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + path
        parsed_uri
      end

      def get_parent_uri
        subpath = *path.split('/')
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase

        else
            parent_uri = 'null'
        end
      end

      def get_type_by_name(typename)
          REPLACE_TYPES[typename] || get_type
      end

      def get_type
         'others'
      end

      def additional_entries
        type = 'others'
        entries = []
        css('h3','h2').each do |node|
          if node.name == 'h2'
            name = node.content.strip
            type = name
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], 'others', custom_parsed_uri, get_parent_uri, get_docset]
          elsif node.name == 'h3'
            name = node.content.strip
            type = name
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type_by_name(type), custom_parsed_uri, get_parent_uri, get_docset]
          end
        end
        entries
      end
    end
  end
end

module Docs
  class Lua
    class EntriesFilter < Docs::ReflyEntriesFilter
      REPLACE_TYPES = {
        'Language' => 'language',
        'Standard Libraries' => 'function',
        'Auxiliary Library' => 'function',
        'Basic Concepts' => 'guide',
        'API' => 'api'
      }
      def get_name
        'Manual'
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        parsed_uri
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name)
        end
        parsed_uri
      end

      def get_type
          'others'
      end
      def get_parent_uri
          parent_uri = 'null'
          parent_uri
      end

      def additional_entries
        type = nil

        doc.children.each_with_object [] do |node, entries|
          if node.name == 'h1'
            type = node.content.strip
            type.remove! %r{.+\u{2013}\s+}
            type.remove! 'The '
            type = 'API' if type == 'Application Program Interface'
          end

          next if type && type.include?('Incompatibilities')
          next if node.name == 'h2' && type.in?(%w(API Auxiliary\ Library Standard\ Libraries))

          if node.name == 'h2' || node.name == 'h3'
            name = node.content
            name.remove! %r{.+\u{2013}\s+}
            name.remove! %r{\[.+\]}
            name.gsub! %r{\s+\(.*\)}, '()'
            custom_parsed_uri = get_parsed_uri_by_name(name)
            custom_parent_uri = '/lua/manual'
            entries << [name, node['id'], REPLACE_TYPES[type] || type, custom_parsed_uri, custom_parent_uri, get_docset]
          end
        end
      end
    end
  end
end

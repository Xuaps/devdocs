module Docs
  class Q
    class EntriesFilter < Docs::EntriesFilter
      REPLACE_TYPES = {
        'Custom Messaging' => 'function',
        'Q.defer()' => 'function'
      }

      def get_name
        'Index'
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

      def get_parsed_uri_by_name(name)
        parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        parsed_uri
      end

      def get_parent_uri
          parent_uri = 'null'
          parent_uri
      end

      def get_type
        'others'
      end

      def additional_entries
        entry = type = nil
        css('h3, h4, em:contains("Alias")').each_with_object [] do |node, entries|
          case node.name
          when 'h3'
            type = node.content.strip
            type.remove! %r{\(.+\)}
            type.remove! ' Methods'
            type.remove! ' API'
            custom_parsed_uri = get_parsed_uri_by_name(type)
            entries << [type, node['id'], REPLACE_TYPES[type] || type, custom_parsed_uri, get_parent_uri, get_docset] if type == 'Q.defer()'
          when 'h4'
            name = node.content.strip
            name.sub! %r{\(.*?\).*}, '()'
            id = node['id'] = name.parameterize
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entry = [name, id, REPLACE_TYPES[type.strip] || type, custom_parsed_uri, get_parent_uri, get_docset]
            entries << entry
          when 'em'
            name = node.parent.at_css('code').content
            name << '()' if entry[0].end_with?('()')
            dup = entry.dup
            custom_parsed_uri = get_parsed_uri_by_name(name)
            dup[0] = name
            dup[3] = custom_parsed_uri
            entries << dup
          end
        end
      end
    end
  end
end

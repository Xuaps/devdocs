module Docs
  class Maxcdn
    class EntriesFilter < Docs::ReflyEntriesFilter

      REPLACE_TYPES = {
        'SSL Certificate' => 'security',
        'Zones SSL' => 'security',
        'Users' => 'function',
        'Account' => 'function',
        'Raw Logs' => 'function',
        'Reports' => 'function',
      }
      def get_name
        name = at_css('h1').content.strip
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        else
            parsed_uri = get_parsed_uri + '/' + self.urilized(name)
        end
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

      def get_parent_uri
        'null'
      end

      def get_type
        'others'
      end
      def get_type_by_name(name)
        REPLACE_TYPES[name] || 'others'
      end

      def additional_entries
        type = id_prefix = nil

        doc.children.each_with_object [] do |node, entries|
          if node.name == 'h2'
            type = node.content.strip
            type.remove! %r{ API\z}
            type.remove! ' Custom Domains'
            id_prefix = type.parameterize
            type = 'Reports' if type.starts_with? 'Reports'
          elsif node.name == 'h3'
            next unless type
            name = node.content.strip
            id = "#{id_prefix}-#{name}".parameterize
            node['id'] = id

            if name.ends_with?('Domain') && ['Push Zone', 'Pull Zone', 'VOD Zone'].include?(type)
              name << " (#{type})"
            end
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, id, get_type_by_name(type), custom_parsed_uri, get_parsed_uri, get_docset]
          end
        end
      end
    end
  end
end

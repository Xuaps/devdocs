module Docs
  class Socketio
    class EntriesFilter < Docs::ReflyEntriesFilter
      def get_name
        at_css('h1').content
      end
      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        parsed_uri = get_parsed_uri + '/' + self.urilized(name)
        parsed_uri
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        parsed_uri
      end

      def get_parent_uri
        'null'
      end
      def get_type
        'guide'
      end

      def get_type_by_name(name)
        type = 'others'
        if name.start_with? 'IO'
            type = 'io'
        elsif name.start_with? 'Namespace'
            type = 'namespace'
        elsif name.start_with? 'Manager'
            type = 'function'
        elsif name.start_with? 'Server'
            type = 'network'
        elsif name.start_with? 'Socket'
            type = 'network'
        elsif name.include? 'Logging'
            type = 'guide'
        elsif name.include? 'Migration'
            type = 'guide'
        elsif name.include? 'Using'
            type = 'guide'
        else
            type = 'others'
        end
        type
      end

      def additional_entries
        return [] unless slug.end_with?('api')

        css('h3').each_with_object([]) do |node, entries|
          name = node.content
          name.remove! %r{\(.*}
          name.remove! %r{\:.*}
          name.tr!('#','.')
          unless entries.any? { |entry| entry[0] == name }
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type_by_name(name), custom_parsed_uri, get_parsed_uri, get_docset]
          end
        end
      end
    end
  end
end

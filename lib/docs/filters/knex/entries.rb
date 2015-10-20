module Docs
  class Knex
    class EntriesFilter < Docs::ReflyEntriesFilter

      def get_name
        'Index'
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(name)
        end
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
        'others'
      end

      def get_type_by_id(id)
        if id.starts_with? 'Schema'
          type = 'function'
        elsif id.starts_with? 'Raw'
          type = 'expression'
        elsif id.starts_with? 'Chainable'
          type = 'method'
        elsif id.starts_with? 'Promises' or id.starts_with? 'Interfaces'
          type = 'interface'
        elsif id.starts_with? 'Events'
          type = 'event'
        elsif id.starts_with? 'Migrations'
          type = 'migrations'
        else
          type = 'others'
        end
        type
      end

      def additional_entries
        entries = []
        css('h2[id]', 'h3[id]', 'p[id]').each do |node|
          if node.name == 'p'
            id = node['id']
            name = node.css('b').first.content.strip.remove ':'
          else
            id = node['id']
            name = node.content.strip.remove ':'
          end
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, id, get_type_by_id(id), custom_parsed_uri, get_parent_uri, get_docset]
        end
        entries
      end
    end
  end
end

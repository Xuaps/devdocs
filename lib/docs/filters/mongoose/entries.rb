module Docs
  class Mongoose
    class EntriesFilter < Docs::ReflyEntriesFilter
      def get_name
        if slug == 'index'
          name = 'Getting Started'
        else
          name = at_css('h1').content
        end
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
            parsed_uri = get_parent_uri + '/' + self.urilized(name)
        end
        parsed_uri
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        parsed_uri
      end

      def get_parent_uri
        parent_uri = 'null'
      end

      def get_type
        if slug == 'api'
          'language'
        else
          'guide'
        end
      end

      def get_type_name(name)
        if name.include? 'Collection' or  name.include? 'Array'
          'collection'
        elsif name.include? 'Schema'
          'schema'
        elsif name.include? 'Connection' or  name.include? 'Query'
          'network'
        elsif name.include? 'Mongoose' or name.include? 'VirtualType'
          'language'
        elsif name.include? 'Object' or name.include? 'Validation'
          'object'
        else
          'others'
        end
      end

      def additional_entries
        entries = []
        entries << ['Getting Started', nil, 'others', '/mongoosejs/getting_started', 'null', get_docset] if slug == 'index'
        return [] unless slug == 'api'

        css('h3[id]').each do |node|
          next if node['id'] == 'index_'
          name = node.content.strip
          name.sub! %r{\(.+\)}, '()'
          next if name.include?(' ') or name == '()'

          name = name.tr('#','.')
          type = name.split(/[#\.\(]/).first
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type_name(name), custom_parsed_uri, get_parsed_uri, get_docset]
        end

        entries
      end
    end
  end
end

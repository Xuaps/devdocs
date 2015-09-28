module Docs
  class Mongoose
    class EntriesFilter < Docs::ReflyEntriesFilter
      def get_name
        if slug == 'api'
          'Index'
        else
          at_css('h1').content
        end
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
          entries << [name, node['id'], get_type_name(name), custom_parsed_uri, get_parent_uri, get_docset]
        end

        entries
      end
    end
  end
end

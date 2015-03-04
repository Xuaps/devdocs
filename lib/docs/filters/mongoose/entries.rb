module Docs
  class Mongoose
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        if slug == 'api'
          'Mongoose'
        else
          at_css('h1').content
        end
      end

      def get_docset
        docset = context[:root_title]
        docset
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
          'Mongoose'
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
          'Mongoose'
        elsif name.include? 'Object' or name.include? 'Validation'
          'object'
        else
          'others'
        end
      end

      def additional_entries
        return [] unless slug == 'api'
        entries = []

        css('h3[id]').each do |node|
          next if node['id'] == 'index_'

          name = node.content.strip
          name.sub! %r{\(.+\)}, '()'
          next if name.include?(' ')

          type = name.split(/[#\.\(]/).first
          custom_parsed_uri = get_parsed_uri + '#' + node['id']
          entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end

        entries
      end
    end
  end
end

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
          'Guides'
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
          entries << [name, node['id'], type, get_parsed_uri, get_parent_uri, get_docset]
        end

        entries
      end
    end
  end
end

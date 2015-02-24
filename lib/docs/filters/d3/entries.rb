module Docs
  class D3
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        at_css('h1').content
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
        name
      end

      def additional_entries
        css('h6[id]').inject [] do |entries, node|
          name = node.content.strip
          name.remove! %r{\(.*\z}
          name.sub! %r{\A(svg:\w+)\s+.+}, '\1'
          entries << [name, node['id']] unless name == entries.last.try(:first)
          entries
        end
      end
    end
  end
end

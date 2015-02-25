module Docs
  class Express
    class EntriesFilter < Docs::EntriesFilter
 
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

      def additional_entries
        type = 'Application'

        doc.children.each_with_object [] do |node, entries|
          if node.name == 'h2'
            type = node.content
            entries << [type, node['id'], 'Application'] if type == 'Middleware'
            next
          elsif node.name == 'h3'
            next if type == 'Middleware'
            name = node.content.strip
            name.sub! %r{\(.+\)}, '()'

            entries << [name, node['id'], type, get_parsed_uri, get_parent_uri, get_docset]
          end
        end
      end
    end
  end
end

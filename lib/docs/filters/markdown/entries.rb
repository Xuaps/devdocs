module Docs
  class Markdown
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

      def get_type
          'others'
      end

      def additional_entries
        type = 'others'
        doc.children.each_with_object [] do |node, entries|
          if node.name == 'h2'
            type = node.content.strip
          elsif node.name == 'h3'
            name = node.content.strip
            custom_parsed_uri = get_parsed_uri + '#' + node['id']
            entries << [name, node['id'], type, custom_parsed_uri, get_parent_uri, get_docset]
          end
        end
      end
    end
  end
end

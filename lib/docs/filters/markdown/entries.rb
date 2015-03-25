module Docs
  class Markdown
    class EntriesFilter < Docs::EntriesFilter

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
          context[:docset_uri] + '/' + self.urilized(name)
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

      def get_type(typename)
          if typename == 'Overview'
              'guide'
          elsif typename == 'Miscellaneous'
              'others'
          elsif typename == 'Block Elements'
              'element'
          elsif typename == 'Span Elements'
              'element'
          else
               'others'
          end
      end

      def additional_entries
        type = 'others'
        doc.children.each_with_object [] do |node, entries|
          if node.name == 'h2'
            name = node.content.strip
            type = name
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], 'others', custom_parsed_uri, get_parent_uri, get_docset]
          elsif node.name == 'h3'
            name = node.content.strip
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type(type), custom_parsed_uri, get_parent_uri, get_docset]
          end
        end
      end
    end
  end
end

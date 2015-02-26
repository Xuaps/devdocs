module Docs
  class Phpunit
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
        if name.in?(%w(Assertions Annotations))
          name
        else
          'Guides'
        end
      end

      def additional_entries
        return [] if type == 'Guides'

        css('h2').map do |node|
          [node.content, node['id'], type, get_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

module Docs
  class Phpunit
    class EntriesFilter < Docs::ReflyEntriesFilter
      def get_name
        if at_css('h1')
          at_css('h1').content
        else
          'PHPUnit'
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
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name)
        end
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
        if name.in?(%w(Assertions))
          'function'
        elsif name.in?(%w(Annotations))
          'property'
        else
          'guide'
        end
      end

      def additional_entries
        return [] if type == 'guide'

        css('h2').map do |node|
          name = node.content
          custom_parsed_uri = get_parsed_uri_by_name(name)
          [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

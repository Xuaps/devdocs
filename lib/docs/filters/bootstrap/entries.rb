module Docs
  class Bootstrap
    class EntriesFilter < Docs::ReflyEntriesFilter

      def get_name
        if slug == 'css/'
          name = slug.upcase.remove '/'
        else
          name = slug.titleize.remove('/').tr('-', ' ')
        end
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name)
        end
        parsed_uri
      end

      def get_parsed_uri_by_name(name)
        parsed_uri = get_parsed_uri + '/' + self.urilized(name)
        parsed_uri
      end

      def get_parent_uri
       'null'
      end

      def get_type
        if get_name == 'Getting Started'
          'others'
        else
          get_name.downcase
        end
      end

      def additional_entries
        entries = []
        css('h2', 'h1').each do |node|
            name = node.content.strip
            custom_parsed_uri = get_parsed_uri_by_name(name)
            custom_parent_uri = get_parsed_uri
            entries << [name, node['id'], get_type, custom_parsed_uri, custom_parent_uri, get_docset]
        end
        entries
      end
    end
  end
end

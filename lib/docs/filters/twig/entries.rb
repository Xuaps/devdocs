module Docs
  class Twig
    class EntriesFilter < Docs::ReflyEntriesFilter

      EXCLUDED_PATH = ['MySQL 5.7 Reference Manual']

      def get_name
        if css('h1').to_s != ''
          name = css('h1').first.content.strip
        else
          name = slug.capitalize
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

      def get_parent_uri
        'null'
      end

      def get_type
        type = 'others'
        if css('div.type').to_s != ''
          type = css('div.type').first.content.downcase.strip
          if type == 'index'
            type = 'others'
          end
        end
        type
      end
    end
  end
end

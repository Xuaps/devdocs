module Docs
  class Scala
    class EntriesFilter < Docs::ReflyEntriesFilter
      def get_name
        if at_css('h1')
          name = at_css('h1').content.strip
        end
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
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
        parent_uri = 'null'
        parent_uri
      end

      def get_type
        if css('#signature')
          type = css('#signature .kind').first.content.remove 'case '
        else
          type = 'others'
        end
        type
      end

      def include_default_entry?
        doc.at_css('h1') && !doc.at_css('#indextitle')
      end
    end
  end
end

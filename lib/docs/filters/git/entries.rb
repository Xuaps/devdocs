module Docs
  class Git
    class EntriesFilter < Docs::ReflyEntriesFilter
      def get_name
        name = path
        name
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
          parent_uri = 'null'
      end

      def get_type
        node = css('p')
        if node[0]
            if node[0].inner_text.downcase.include? ' show '
                'lists'
            elsif node[0].inner_text.downcase.include? ' list '
                return 'lists'
            elsif node[0].inner_text.downcase.include? '  '
                'function'
            elsif node[2].inner_text.downcase.include? ' method '
                return 'method'
            else
               'function'
            end
        else
            'others'
        end
      end

    end
  end
end

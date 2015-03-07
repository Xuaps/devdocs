module Docs
  class Git
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        slug.sub '-', ' '
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

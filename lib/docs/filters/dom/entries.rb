module Docs
  class Dom
    class EntriesFilter < Docs::ReflyEntriesFilter
      CLEANUP_NAMES = %w(
        CSS\ Object\ Model.
        Web\ Audio\ API.
        IndexedDB\ API.
        MediaRecorder\ API.
        Tutorial.
        XMLHttpRequest.)
      EXCLUDED_PATH = ['MDN','Web technology for developers', 'Web API Interfaces', 'Web APIs']
      def get_name
        if css('h1')
            name = css('h1').first.content
        else
            name = 'Index'
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
        parent_uri = context[:docset_uri]
        css('.crumb a').each do |node|
          link = node.content
           if not EXCLUDED_PATH.include? link
              parent_uri += '/' + self.urilized(link)
           end
        end
        if parent_uri == context[:docset_uri]
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        node = css('p')
        if node[2]
            if node[2].inner_text.downcase.include? ' interface '
                'object'
            elsif node[2].inner_text.downcase.include? ' property '
                return 'property'
            elsif node[2].inner_text.downcase.include? ' event '
                'event'
           elsif node[2].inner_text.downcase.include? ' method '
                return 'method'
           else
               'others'
            end
        else
            'others'
        end
      end


    end
  end
end

module Docs
  class Dom
    class EntriesFilter < Docs::EntriesFilter
      CLEANUP_NAMES = %w(
        CSS\ Object\ Model.
        Web\ Audio\ API.
        IndexedDB\ API.
        MediaRecorder\ API.
        Tutorial.
        XMLHttpRequest.)

      def get_name
        name = super
        CLEANUP_NAMES.each { |str| name.remove!(str) }
        name.sub! 'Input.', 'HTMLInputElement.'
        name.sub! 'window.navigator', 'navigator'
        name.sub! 'API.', 'API: '
        # Comment.Comment => Comment.constructor
        name.sub! %r{\A(\w+)\.\1\z}, '\1.constructor' unless name == 'window.window'
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
        subpath = *path.split('/')
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            parent_uri = 'null'
        end
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

      def include_default_entry?
        (node = doc.at_css '.overheadIndicator').nil? ||
        type == 'Console' ||
        (node.content.exclude?('not on a standards track') && node.content.exclude?('removed from the Web'))
      end
    end
  end
end

module Docs
  class Grunt
    class EntriesFilter < Docs::EntriesFilter
      NULL_PARENT_URIs = %w(api)
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
            if NULL_PARENT_URIs.include? subpath[subpath.size-1]
               parent_uri = 'null'
            end
        else
            parent_uri = 'null'
        end
      end

      def get_type
        if name.include? 'config'
            'Configs'
        elsif name.include? 'event'
            'Events'
        elsif name.include? 'fail'
            'Fails'
        else
          'others'
        end
      end

      def additional_entries
        return [] unless subpath.starts_with?('api')

        css('h3').each_with_object [] do |node, entries|
          name = node.content
          name.remove! %r{\s.+\z}

          next if name == self.name

          entries << [name + '#' + node['id'], node['id'], get_type, get_parsed_uri + '#' + node['id'], get_parent_uri, get_docset]
        end
      end

      def include_default_entry?
        name != 'Inside Tasks'
      end
    end
  end
end

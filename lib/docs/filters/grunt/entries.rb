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
            'configuration'
        elsif name.include? 'event'
            'event'
        elsif name.include? 'fail'
            'error'
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
          custom_parsed_uri = get_parsed_uri + '#' + node['id']
          entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end

      def include_default_entry?
        name != 'Inside Tasks'
      end
    end
  end
end

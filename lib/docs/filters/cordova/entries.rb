module Docs
  class Cordova
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        at_css('h1').content.remove(' Guide')
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
        if subpath.start_with?('guide_platforms')
          name[/Amazon\ Fire\ OS|Android|BlackBerry|Firefox OS|iOS|Windows/] || 'Platform Guides'
        else
          'Guides'
        end
      end

      def additional_entries
        return [] unless slug == 'cordova_events_events.md'

        css('h2').map do |node|
          [node.content, node['id'], 'Events']
        end
      end
    end
  end
end

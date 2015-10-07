module Docs
  class Cordova
    class EntriesFilter < Docs::ReflyEntriesFilter
      def get_name
        if at_css('h1')
          at_css('h1').content.remove(' Guide')
        else
          'Cordova'
        end
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
        parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        parsed_uri
      end

      def get_parent_uri
        parent_uri = 'null'
      end

      def get_type
        if slug.include? 'guide'
          'guide'
        elsif slug.include? 'event'
          'event'
        else
          'others'
        end
      end

      def additional_entries
        return [] unless slug == 'cordova_events_events.md'

        css('h2').map do |node|
          name = node.content
          custom_parsed_uri = get_parsed_uri_by_name(name)
          [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

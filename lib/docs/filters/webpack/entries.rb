module Docs
  class Webpack
    class EntriesFilter < Docs::EntriesFilter

      REPLACE_TYPES = {
        'guides' => 'guide',
        'getting started' => 'guide',
        'api' => 'api',
        'webpack with' => 'platforms',
        'dev tools' => 'tools',
        'home' => 'others',
        'lists' => 'lists'
      }
      def get_name
        entry_link.content
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
        link_li = entry_link.parent
        type_links_list = link_li.parent
        current_type = type_links_list.parent

        # current type is a
        # <li>
        #   TYPE
        #   <li> <ul> .. links .. </ul> </li>
        # </li>
        #
        # Grab the first children (which is the text nodes whose contains the type)
        REPLACE_TYPES[current_type.children.first.content.strip.downcase]
      end

      private

      def entry_link
        at_css("a[href='#{self.path}']")
      end
    end
  end
end


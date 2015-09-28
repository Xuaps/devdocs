module Docs
  class Opentsdb
    class EntriesFilter < Docs::ReflyEntriesFilter
      REPLACE_TYPES = {
        'User Guide' => 'guide',
        'Development' => 'guide'
      }
      def get_name
        at_css('.section > h1').content
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
          if breadcrumbs.length >= 2
            breadcrumbs.each do |node|
                if self.urilized(node)!= 'opentsdb_2.1_documentation'
                  parent_uri += '/' + self.urilized(node)
                end
            end
          else
            parent_uri = 'null'
          end
          parent_uri
      end

      def get_type
        if breadcrumbs.length >= 2 and (breadcrumbs[1].include? 'Guide' or breadcrumbs[1].include? 'Development')
          type ='guide'
        elsif subpath.start_with?('api_http')
          type = 'api'
        elsif slug.end_with?('/index')
          type = [breadcrumbs[1], name].compact.join(': ')
        elsif breadcrumbs.length < 2
          type = 'others'
        else
          type = breadcrumbs[1]
        end
        REPLACE_TYPES[type] || type
      end

      def breadcrumbs
        @breakcrumbs ||= at_css('.related').css('li:not(.right) a').map(&:content).reject(&:blank?)
      end
    end
  end
end

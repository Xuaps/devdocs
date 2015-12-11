module Docs
  class Dojo
    class EntriesFilter < Docs::ReflyEntriesFilter
      def get_name
        if at_css('h1')
          at_css('h1').content.remove(/\(.*\)/).remove('dojo/').strip
        else
          'Index'
        end
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name)
        end
        parsed_uri
      end

      def get_parsed_uri_by_name(name)
        parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        parsed_uri
      end

      def get_parent_uri
          parent_uri = 'null'
          parent_uri
      end
      def get_type
        path = get_name.split(/[\/\.\-]/)
        path[0] == '_base' ? path[0..1].join('/') : path[0]
      end

      def additional_entries
        entries = []

        css('.jsdoc-summary-list li.functionIcon:not(.private):not(.inherited) > a').each do |node|
          name = "#{self.name}.#{node.content}()"
          id = node['href'].remove('#')
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, id, get_type, custom_parsed_uri, get_parsed_uri, get_docset]
        end

        css('.jsdoc-summary-list li.objectIcon:not(.private):not(.inherited) > a').each do |node|
          name = "#{self.name}.#{node.content}"
          id = node['href'].remove('#')
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, id, get_type, custom_parsed_uri, get_parsed_uri, get_docset]
        end

        entries
      end
    end
  end
end

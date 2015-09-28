module Docs
  class Modernizr
    class EntriesFilter < Docs::ReflyEntriesFilter

      def get_name
        'Index'
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
        'null'
      end

      def get_type
        'others'
      end

      def get_type_by_name(_type)
        if _type.include? 'Miscellaneous features'
          'others'
        elsif _type.include? 'Modernizr'
          'function'
        elsif _type.include? 'CSS features'
          'css'
        elsif _type.include? 'HTML5 features'
          'html5'
        else
          'others'
        end
      end
      def additional_entries
        entries = []
        css('h3[id]').each do |node|
          name = node.content
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], 'function', custom_parsed_uri, 'null', get_docset]
        end
        css('section[id]').each do |node|
          next unless heading = node.at_css('h3')
          name = heading.content

          heading['id'] = node['id']
          node.remove_attribute('id')

          name.prepend('Modernizr.') unless name.start_with?('Modernizr')
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, heading['id'], 'function', custom_parsed_uri, 'null', get_docset]
        end

        css('h4[id^="features-"] + table').each do |table|
          type = table.previous_element.content.strip
          type << ' features' unless type.end_with?('features')

          table.css('tbody th[id]').each do |node|
            name = node.content.strip
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [node.content, node['id'], get_type_by_name(type), custom_parsed_uri, 'null', get_docset]
          end
        end
        entries
      end
    end
  end
end

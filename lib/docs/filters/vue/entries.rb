module Docs
  class Vue
    class EntriesFilter < Docs::ReflyEntriesFilter
      REPLACE_TYPES = {
        'Component Options' => 'component',
        'Component System' => 'component',
        'Special Elements' => 'component',
        'Filters' => 'filter',
        'Custom Filters' => 'filter',
        'Common FAQs' => 'guide',
        'Getting Started' => 'guide',
        'Global API' => 'guide',
        'Installation' => 'guide',
        'Directives' => 'directive',
        'Custom Directives' => 'directive',
        'Displaying a List' => 'directive',
        'Handling Forms' => 'directive',
        'Computed Properties' => 'property',
      }
      def get_name
        at_css('h1').content
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
        REPLACE_TYPES[self.name] || 'others'
      end
      def get_custom_type(name)
        if name.include? '()' or name.include? 'method'
          type = 'method'
        elsif name.include? 'vm.' or name.include? 'Properties'
          type = 'property'
        elsif name == 'Tips & Best Practices' or name == 'Building Larger Apps' or name == 'Extending Vue' or name == 'Overview'
          type = 'guide'
        else
          type = self.name || 'others'
        end
        REPLACE_TYPES[type] || type
      end

      def additional_entries
        return [] if slug.start_with?('guide')

        css('h3').map do |node|
          name = node.content.strip
          name.sub! %r{\(.*\)}, '()'
          custom_parsed_uri = get_parsed_uri_by_name(name)
          [name, node['id'], get_custom_type(name), custom_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

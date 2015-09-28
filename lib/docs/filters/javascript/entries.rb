module Docs
  class Javascript
    class EntriesFilter < Docs::ReflyEntriesFilter
      TYPES = %w(Array ArrayBuffer Boolean DataView Date Function Intl JSON Map
        Math Number Object Promise RegExp Set String Symbol TypedArray WeakMap
        WeakSet)
      INTL_OBJECTS = %w(Collator DateTimeFormat NumberFormat)

      EXCLUDED_PATH = ['MDN','Web technology for developers', 'JavaScript']
     def get_name
        name = css('h1').first.content
        if name == ''
          name = slug
        end
        name
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
        xpath('//nav[@class="crumbs"]//a/text()').each do |node|
           link = node.content.strip
           if not EXCLUDED_PATH.include? link
              parent_uri += '/' + self.urilized(link)
           end
        end
        if parent_uri == context[:docset_uri]
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        node = css('#Syntax')
        if node.inner_text == 'Constructor'
            'class'
        elsif node.inner_text == 'Syntax'
            'method'
        else
            if slug.start_with? 'Statements'
                'statements'
            elsif slug.start_with? 'Operators'
                'expression'
            elsif slug.start_with?('Functions_and_function_scope') || slug.start_with?('Functions') || slug.include?('GeneratorFunction')
                'function'
            elsif slug.start_with? 'Global_Objects' 
                'class'
            else
                'others'
            end
        end
      end

      def include_default_entry?
        #node = doc.at_css '.overheadIndicator'

        # Can't use :first-child because #doc is a DocumentFragment
        return true #unless node && node.parent == doc && !node.previous_element

        #!node.content.include?('not on a standards track') &&
        #!node.content.include?('removed from the Web') &&
        #!node.content.include?('could be removed at any time')
      end
    end
  end
end

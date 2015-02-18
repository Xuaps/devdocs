module Docs
  class Javascript
    class EntriesFilter < Docs::EntriesFilter
      TYPES = %w(Array ArrayBuffer Boolean DataView Date Function Intl JSON Map
        Math Number Object Promise RegExp Set String Symbol TypedArray WeakMap
        WeakSet)
      INTL_OBJECTS = %w(Collator DateTimeFormat NumberFormat)


      def get_name
        puts slug
        if slug.start_with? 'Global_Objects/'
          subnames = *slug.sub('Global_Objects/', '').split('/')
          if subnames.size>2
            name = subnames[1]
            method = subnames[2]
          else
            name = subnames[0]
            method = subnames[1]
          end
          name.prepend 'Intl.' if INTL_OBJECTS.include?(name)
          if method
            unless method == method.upcase || method == 'NaN'
              method = method[0].downcase + method[1..-1] # e.g. Trim => trim
            end
            name << ".#{method}"
          end

          name
        else
          name = super
          name.remove! 'Functions.'
          name.remove! 'Functions and function scope.'
          name.remove! 'Operators.'
          name.remove! 'Statements.'
          name
        end
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
        node = doc.at_css '.overheadIndicator'

        # Can't use :first-child because #doc is a DocumentFragment
        return true unless node && node.parent == doc && !node.previous_element

        !node.content.include?('not on a standards track') &&
        !node.content.include?('removed from the Web') &&
        !node.content.include?('could be removed at any time')
      end
    end
  end
end

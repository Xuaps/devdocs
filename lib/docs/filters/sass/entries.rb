module Docs
  class Sass
    class EntriesFilter < Docs::ReflyEntriesFilter
      TYPES = ['CSS Extensions', 'SassScript', '@-Rules and Directives',
        'Output Styles', 'Selector']

      SKIP_NAMES = ['Interactive Shell', 'Data Types', 'Operations',
        'Division and /', 'Keyword Arguments']

      REPLACE_NAMES = {
        '%foo'               => '%placeholder selector',
        '&'                  => '& parent selector',
        '$'                  => '$ variables',
        '`'                  => '#{} interpolation',
        'The !optional Flag' => '!optional'
      }

      def get_name
        at_css('h1').content
      end
        
      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
          context[:docset_uri] + '/' + self.urilized(name)
      end

      def get_parsed_uri
        subpath = *path.split('/')
        parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        parsed_uri
      end

      def get_parent_uri
          parent_uri = 'null'
      end

      def get_type_by_name(typename)
          if typename == 'SassScript'
              'language'
          elsif typename == 'Functions'
              'function'
          elsif typename == '@-Rules and Directives'
              'directives'
          elsif typename == 'Output Styles' or typename == 'CSS Extensions' or typename == 'Selector'
              'styles'
          else
             'others'
          end
      end

      def get_type()
         'others'
      end

      def include_default_entry?
        false
      end

      def additional_entries
        return root_entries if slug == 'file.SASS_REFERENCE'
        return function_entries if slug == 'Sass/Script/Functions'
        return []
      end

      def root_entries
        entries = []
        type = ''

        css('dt[id]','> [id]').each do |node|
          if node.name == 'h2'
            type = node.content.strip
            if type == 'Function Directives'
              name = '@function'
              custom_parsed_uri = get_parsed_uri_by_name(name)
              entries << [name, node['id'], get_type_by_name('@-Rules and Directives'), custom_parsed_uri, get_parent_uri, get_docset]
            end

            if type.include? 'Directives'
              type = '@-Rules and Directives'
            elsif type == 'Output Style'
              type = 'Output Styles'
            end

            next
          elsif node.name == 'dt'
             type = 'Selector'
          end

          next unless TYPES.include?(type)

          name = node.content.strip
          name.remove! %r{\A.+?: }

          next if SKIP_NAMES.include?(name)

          name = REPLACE_NAMES[name] if REPLACE_NAMES[name]
          name.gsub!(/ [A-Z]/) { |str| str.downcase! }

          if type == '@-Rules and Directives'
            next unless name =~ /\A@[\w\-]+\z/ || name == '!optional'
          end
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type_by_name(type), custom_parsed_uri, get_parent_uri, get_docset]
        end

        entries
      end

      def function_entries
        css('h2', '.method_details > .signature').inject [] do |entries, node|
          if node.name == 'h2'
              name = node.content
          else
              name = node.at_css('strong').content.strip
          end
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type_by_name('Functions'), custom_parsed_uri, get_parent_uri, get_docset]
          entries
        end
      end
    end
  end
end

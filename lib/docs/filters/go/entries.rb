module Docs
  class Go
    class EntriesFilter < Docs::ReflyEntriesFilter
      FUNCTION_TYPES = %w(math text image crypto time hash archive compress regexp)
      IO_TYPES = %w(io bufio mime encoding path fmt )
      CORE_TYPES = %w(syscall go log builtin os runtime debug unsafe testing)
      TYPE_TYPES = %w(strings bytes unicode sync reflect sort expvar flag container strconv)
      NETWORK_TYPES = %w(net html database)
      def get_name
        name = at_css('h1').content
        name.remove! 'Package '
        name.remove! 'Directory /src/'
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        parsed_uri = get_parsed_uri + '/' + self.urilized(name)
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
        parent_uri = 'null'
        parent_uri
      end

      def get_type
        type = subpath[/\A[^\/]+/]
        if FUNCTION_TYPES.include? type
            type = 'function'
        elsif IO_TYPES.include? type
            type = 'io'
        elsif CORE_TYPES.include? type
            type = 'core'
        elsif TYPE_TYPES.include? type
            type = 'type'
        elsif NETWORK_TYPES.include? type
            type = 'network'
        else
            type = 'others'
        end
        type
      end

      def additional_entries
        css('#manual-nav a').each_with_object [] do |node, entries|
          case node.content
          when /type\ (\w+)/
            name = "#{$1} (#{self.name})"
          when /func\ (?:\(.+\)\ )?(\w+)\(/
            name = "#{$1}() (#{self.name})"
            name.prepend "#{$1}." if node['href'] =~ /#(\w+)\.#{$1}/
          when 'Constants'
            name = "#{self.name} constants"
          when 'Variables'
            name = "#{self.name} variables"
          else
            name = node.content
          end
          custom_parsed_uri = get_parsed_uri_by_name(name)
          #TODO
          if get_parsed_uri == '/go/go_programming_language'
              entries << [name, node['href'][1..-1], get_type, custom_parsed_uri, 'null', get_docset] if name
          else
              entries << [name, node['href'][1..-1], get_type, custom_parsed_uri, get_parsed_uri, get_docset] if name
          end
        end
      end

    end
  end
end

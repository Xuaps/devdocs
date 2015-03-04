module Docs
  class Go
    class EntriesFilter < Docs::EntriesFilter
      FUNCTION_TYPES = %w(math text image crypto time hash archive compress regexp)
      IO_TYPES = %w(io bufio mime encoding path fmt )
      CORE_TYPES = %w(syscall go log builtin os runtime debug unsafe testing)
      TYPE_TYPES = %w(strings bytes unicode sync reflect sort expvar flag container strconv)
      NETWORK_TYPES = %w(net html database)
      def get_name
        name = at_css('h1').content
        name.remove! 'Package '
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + path.sub('/index', '')
        parsed_uri
      end

      def get_parent_uri
        subpath = *path.sub('/index', '').split('/')
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            parent_uri = 'null'
        end
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
          end
          custom_parsed_uri = get_parsed_uri + node['href']
          entries << [name, node['href'][1..-1], get_type, custom_parsed_uri, get_parent_uri, get_docset] if name
        end
      end

      def include_default_entry?
        path!='go/build/index'
      end
    end
  end
end

module Docs
  class Go
    class EntriesFilter < Docs::EntriesFilter
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
        subpath[/\A[^\/]+/]
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

          entries << [name, node['href'][1..-1]] if name
        end
      end

      def include_default_entry?
        !at_css('h1 + table.dir')
      end
    end
  end
end

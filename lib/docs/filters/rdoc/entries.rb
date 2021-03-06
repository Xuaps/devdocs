module Docs
  class Rdoc
    class EntriesFilter < Docs::ReflyEntriesFilter
      def get_name
        name = at_css('h1, h2').content.strip
        name.remove! "\u{00B6}" # remove pilcrow sign
        name.remove! "\u{2191}" # remove up arrow sign
        name.remove! 'class '
        name.remove! 'module '
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
        subpath = *path.split('/')
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        type = get_name

        unless type.gsub! %r{::.*\z}, ''
          parent = at_css('.meta-parent').try(:content).to_s
          return 'Errors' if type.end_with?('Error') || parent.end_with?('Error') || parent.end_with?('Exception')
        end

        type
      end

      def include_default_entry?
        true #at_css('> .description p') || css('.documentation-section').any? { |node| node.content.present? }
      end

      def additional_entries
        return [] if root_page?
        require 'cgi'

        css('.method-detail').inject [] do |entries, node|
          name = node['id'].dup
          name.remove! %r{\A\w+?\-.}
          name.remove! %r{\A-(?!\d)}
          name.gsub! '-', '%'
          name = CGI.unescape(name)

          unless name.start_with? '_'
            name.prepend self.name + (node['id'] =~ /\A\w+-c-/ ? '::' : '#')
            custom_parsed_uri = get_parsed_uri + '#' + node['id']
            entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset] unless entries.any? { |entry| entry[0] == name }
          end

          entries
        end
      end
    end
  end
end

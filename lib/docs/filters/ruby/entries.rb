module Docs
  class Ruby
    class EntriesFilter < Docs::EntriesFilter

      def get_name
        if at_css('h1')
          name = at_css('h1').content.strip
          name.remove! "\u{00B6}" # remove pilcrow sign
          name.remove! "\u{2191}" # remove up arrow sign
          name.remove! 'class '
          name.remove! 'module '
        else
          name = slug
        end
        name
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
        parent_uri = 'null'
        parent_uri
      end

      def get_type
        if get_name.include? 'Ruby Standard Library'
          type = 'module'
        elsif css('.parent-class-section')
          type = 'class'
        else
          type = 'others'
        end
        type
      end

      def additional_entries
        entries = []
        css('h3').each do |node|
          name = node.content.strip
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], 'method', custom_parsed_uri, get_parsed_uri, get_docset]
        end
        # css('dt').map do |node|
        #   name = node['id'] = get_name + '::' + node.content.strip.tr('“', '').tr('”', '')
        #   puts get_name + '::' + name
        #   if name.length == 1 and name.downcase == name
        #     custom_parsed_uri = get_parsed_uri_by_name('__' + name)
        #   else
        #     custom_parsed_uri = get_parsed_uri_by_name(name)
        #   end
        #   entries << [name, node['id'], 'constant', custom_parsed_uri, get_parsed_uri, get_docset]
        # end
        entries
      end

      def include_default_entry?
        if !at_css('h1')
          false
        else
          true
        end
      end

      def guide?
        slug =~ /[^\/]+_rdoc/
      end
    end
  end
end
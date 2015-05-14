module Docs
  class Rails
    class EntriesFilter < Docs::EntriesFilter
      EXCLUDED_PATH = ['Libraries']
      def get_name
        if at_css('h1')
          name = at_css('h1').content.strip
          if name.index('::')
            name = name.split('::').last
          end
        else
          name = slug
        end
        name.remove! 'Module: '
        name.remove! 'Class: '
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
        parent_uri = context[:docset_uri]
        xpath('//div[@id="menu"]//a/text()').each do |node|
           link = node.content.strip
           if not EXCLUDED_PATH.include? link and !link.start_with? 'Index'
              parent_uri += '/' + self.urilized(link)
           end
        end
        if parent_uri == context[:docset_uri]
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        if at_css('h1')
          name = at_css('h1').content.strip
        else
          name = 'others'
        end
        if name.start_with? 'Module'
          type = 'module'
        elsif name.start_with? 'Class'
          type = 'class'
        else
          type = 'others'
        end
        type
      end

      def additional_entries
        entries = []
        css('h3.signature').each do |node|
          name = node.content.strip
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], 'method', custom_parsed_uri, get_parsed_uri, get_docset]
        end
        entries
      end
    end
  end
end

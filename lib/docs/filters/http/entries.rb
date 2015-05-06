module Docs
  class Http
    class EntriesFilter < Docs::EntriesFilter
      def get_type
        type = at_css('h1').content.sub(/\A\s*HTTP\s+(.+)\s+Definitions\s*\z/, '\1').pluralize
        if type == 'Status Codes'
            'status code'
        else
             'header'
        end
      end

      def get_parsed_uri_by_name(name)
          context[:docset_uri] + '/' + self.urilized(name)
      end
      
      def get_parent_uri
        subpath = *path.split('/')
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            parent_uri = 'null'
        end
      end

      def include_default_entry?
        false
      end

      def additional_entries
        return [] if root_page?

        css(type == 'status code' ? 'h3' : 'h2').map do |node|
          name = node.content
          puts 'name: ' + name 
          custom_parsed_uri = get_parsed_uri_by_name(name)
          [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

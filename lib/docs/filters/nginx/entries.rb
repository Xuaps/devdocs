module Docs
  class Nginx
    class EntriesFilter < Docs::EntriesFilter
      NULL_PARENT_URIs = %w(http stream)
      def get_name
        name = at_css('h1').content.strip
        name.sub! %r{\AModule ngx}, 'ngx'
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
            #TODO
            if NULL_PARENT_URIs.include? subpath[subpath.size-1]
               parent_uri = 'null'
            end
        else
            parent_uri = 'null'
        end
      end

      def get_type
        if slug.include? 'core'
          'core'
        elsif slug.include? 'module'
          'module'
        else
          'guide'
        end
      end

      def additional_entries
        css('h1 + ul a').each_with_object [] do |node, entries|
          name = node.content.strip
          next if name =~ /\A[A-Z]/

          id = node['href'].remove('#')
          next if id.blank?
          custom_parsed_uri = get_parsed_uri + '#' + id
          entries << [get_name + '.' + name, id, get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

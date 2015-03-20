module Docs
  class D3
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        at_css('h1').content
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
      end

      def get_type
          if slug.downcase.include? 'layout'
              'view'
          elsif slug.downcase.include? 'polygon'
              'object'
          elsif slug.downcase.include? 'math'
               'function'
          elsif slug.downcase.include? 'quadtree'
               'function'
          elsif slug.downcase.include? 'Geom'
               'object'
          elsif slug.downcase.include? 'shapes'
               'object'
          elsif slug.downcase.include? 'localization'
               'function'
          elsif slug.downcase.include? 'scale'
               'function'
          elsif slug.downcase.include? 'namespaces'
               'namespace'
          elsif slug.downcase.include? 'events'
               'event'
          elsif slug.downcase.include? 'time'
               'function'
          else
              'others'
          end
      end

      def additional_entries
        css('h6[id]').inject [] do |entries, node|
          name = node.content.strip
          name.remove! %r{\(.*\z}
          name.sub! %r{\A(svg:\w+)\s+.+}, '\1'
          custom_parsed_uri = get_parsed_uri + '#' + node['id']
          entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset] unless name == entries.last.try(:first)
          entries
        end
      end
    end
  end
end

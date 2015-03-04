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
          if slug.downcase.include? 'layout'
              'Layout'
          elsif slug.downcase.include? 'polygon'
              'Polygon'
          elsif slug.downcase.include? 'math'
               'Math'
          elsif slug.downcase.include? 'quadtree'
               'Quadtree'
          elsif slug.downcase.include? 'Geom'
               'Geometry'
          elsif slug.downcase.include? 'shapes'
               'Shapes'
          elsif slug.downcase.include? 'localization'
               'Localization'
          elsif slug.downcase.include? 'scale'
               'Scale'
          elsif slug.downcase.include? 'namespaces'
               'Namespaces'
          elsif slug.downcase.include? 'events'
               'Events'
          elsif slug.downcase.include? 'time'
               'Time'
          else
              'Others'
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

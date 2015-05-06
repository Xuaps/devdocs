module Docs
  class Xpath
    class EntriesFilter < Docs::EntriesFilter
      
      def get_name
        name = super
        name.remove!('Axes.')
        name << '()' if name.gsub!('Functions.', '')
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
        if slug.start_with?('Axes')
          'axes'
        elsif slug.start_with?('Functions')
          'function'
        else
          'others'
        end
      end
    end
  end
end

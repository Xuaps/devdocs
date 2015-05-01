module Docs
  class React
    class EntriesFilter < Docs::EntriesFilter
      API_SLUGS = %w(
        top-level-api
        component-api
        component-specs
        glossary
      )

      def get_name
        at_css('h1').child.content.strip
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(name)
        end
        parsed_uri
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
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
        if slug.downcase.include? 'component'
            'component'
        elsif slug.downcase.include? 'thinking' or slug.include? 'tutorial' or slug.include? 'dom' or slug.include? 'performance'
            'guide'
        elsif slug.downcase.include? 'event'
            'event'
        elsif slug.downcase.include? 'api'
            'api'
        elsif slug.downcase.include? 'jsx'
            'element'
        else
            'others'
        end

      end

      def additional_entries
        return [] unless API_SLUGS.include?(slug)

        css('.inner-content h3, .inner-content h4, .inner-content h2').map do |node|

          name = node.content
          name.remove! %r{[#\(\)]}
          name.remove! %r{\w+\:}
          id = node.at_css('.anchor')['name']
          custom_parsed_uri = get_parsed_uri_by_name(name)
          [name, id, get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

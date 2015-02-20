module Docs
  class React
    class EntriesFilter < Docs::EntriesFilter
      API_SLUGS = %w(
        top-level-api
        component-api
        component-specs
      )

      def get_name
        at_css('h1').child.content
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
        link = at_css('.nav-docs-section .active')
        section = link.ancestors('.nav-docs-section').first
        section.at_css('h3').content
      end

      def additional_entries
        return [] unless API_SLUGS.include?(slug)

        css('.inner-content h3, .inner-content h4').map do |node|
          name = node.content
          name.remove! %r{[#\(\)]}
          name.remove! %r{\w+\:}
          id = node.at_css('.anchor')['name']
          type = slug.include?('component') ? 'Component' : 'React'
          [name, id, type]
        end
      end
    end
  end
end

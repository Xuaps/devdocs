module Docs
  class React
    class EntriesFilter < Docs::EntriesFilter
      API_SLUGS = %w(
        docs/top-level-api
        docs/component-api
        docs/component-specs
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
        'null'
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
        if API_SLUGS.include?(slug)
          css('.inner-content h3, .inner-content h4').map do |node|
            name = node.content
            name.remove! %r{[#\(\)]}
            name.remove! %r{\w+\:}
            id = node.at_css('.anchor')['name']
            custom_parsed_uri = get_parsed_uri_by_name(name)
            [name, id, get_type, custom_parsed_uri, get_parent_uri, get_docset]

          end
        else
          css('.props > .prop > .propTitle').each_with_object([]) do |node, entries|
            name = node.children.find(&:text?).try(:content)
            next if name.blank?
            sep = node.content.include?('static') ? '.' : '#'
            name.prepend(self.name + sep)
            name << '()' if node.css('.propType').last.content.start_with?('(')
            id = node.at_css('.anchor')['name']
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, id, get_type, custom_parsed_uri, get_parent_uri, get_docset]
          end
        end
      end
    end
  end
end

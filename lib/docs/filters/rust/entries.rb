module Docs
  class Rust
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        if slug == 'book/index'
          'Index'
        elsif slug.start_with?('book')
          at_css("#toc a[href='#{File.basename(slug)}']").content
        elsif slug.start_with?('reference')
          'Reference'
        else
          name = at_css('h1.fqn .in-band').content.remove(/\A.+\s/)
          mod = slug.split('/').first
          name.prepend("#{mod}::") unless name.start_with?(mod)
          name
        end
      end

      PRIMITIVE_SLUG = /\A(\w+)\/(primitive)\./
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
      end

      def get_type
        if slug.start_with?('book')
          'guide'
        elsif slug.start_with?('reference')
          'guide'
        else
          path = name.split('::')
          heading = at_css('h1.fqn .in-band').content.strip
          if path[0] == 'collections'
              'collection'
          elsif path[0] == 'std'
              'language'
          elsif path.length > 2 || (path.length == 2 && (heading.start_with?('Module') || heading.start_with?('Primitive')))
            path[0..1].join('::')
          else
            path[0]
          end
        end
      end

      def additional_entries
        if slug.start_with?('book')
          []
        elsif slug.start_with?('reference')
          css('#TOC > ul > li > a', '#TOC > ul > li > ul > li > a').map do |node|
            name = node.content
            name.sub! %r{(\d)\ }, '\1. '
            name.sub! '10.0.', '10.'
            id = node['href'].remove('#')
            custom_parsed_uri = get_parsed_uri_by_name(name)
            [name, id, get_type, custom_parsed_uri, get_parent_uri, get_docset]
          end
        else
          css('#methods + * + div > .method', '#required-methods + div > .method', '#provided-methods + div > .method').map do |node|
            name = node.at_css('.fnname').content
            name.prepend "#{self.name}::"
            custom_parsed_uri = get_parsed_uri_by_name(name)
            [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
          end
        end
      end
    end
  end
end

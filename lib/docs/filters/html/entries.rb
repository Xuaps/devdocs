module Docs
  class Html
    class EntriesFilter < Docs::EntriesFilter
      HTML5 = %w(content element video)
      OBSOLETE = %w(frame frameset hgroup noframes)

      def get_name
        name = super
        name.remove!('Element.').try(:downcase!)
        name
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
        path = self.path.remove('element/')
        parsed_uri = context[:docset_uri] + '/' + path
        parsed_uri
      end

      def get_parent_uri
        path = self.path.remove('element/')
        subpath = *path.split('/')
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        elsif %w(Attributes Link_types Element/Heading_Elements).include?(slug)
            parent_uri = context[:docset_uri]+ '/' + path
        else
            parent_uri = 'null'
        end
      end

      def get_type
        slug = self.slug.remove('Element/')

        if at_css('.obsoleteHeader', '.deprecatedHeader', '.nonStandardHeader') || OBSOLETE.include?(slug)
          'obsolete'
        else
          spec = css('.standard-table').last.try(:content)
          if (spec && html5_spec?(spec)) || HTML5.include?(slug)
            'type'
          else
            'standard'
          end
        end
      end


      def additional_entries

        if slug == 'Attributes'
          css('.standard-table td:first-child').map do |node|
            name = node.content.strip
            id = node.parent['id'] = name.parameterize + 'tr'
            custom_parsed_uri = get_parsed_uri_by_name(name)
            [name, id, 'attribute', custom_parsed_uri, 'attribute', get_parsed_uri, get_docset]
          end
        elsif slug == 'Link_types'
          css('.standard-table td:first-child > code').map do |node|
            name = node.content.strip
            id = node.parent.parent['id'] = name.parameterize + 'tr'
            name.prepend 'rel: '
            custom_parsed_uri = get_parsed_uri_by_name(name)
            [name, id, 'attribute', custom_parsed_uri, 'attribute', get_parsed_uri, get_docset]
          end
        elsif slug == 'Element/Heading_Elements'
            (1..6).map do |n|
                name = 'h' + n.to_s
                id = name
                custom_parsed_uri = get_parsed_uri_by_name(name)
                [name, id, 'element', custom_parsed_uri, 'element', get_parsed_uri, get_docset]
            end
        else
          []
        end
      end

      def html5_spec?(spec)
        (spec =~ /HTML\s?5/ || spec.include?('WHATWG HTML Living Standard')) && spec !~ /HTML\s?4/
      end
    end
  end
end

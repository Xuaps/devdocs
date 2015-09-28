module Docs
  class Bower
    class EntriesFilter < Docs::ReflyEntriesFilter
      ENTRIES_SLUG = %w(api/ config creating-packages .bowerrc Commands)

      def get_name
        if slug == 'api/'
          'Index'
        else
          at_css('h1').content
        end
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
        if slug.include? 'api'
            'api'
        elsif slug.include? 'config'
            'configuration'
        else
            'guide'
        end
      end

      def include_default_entry?
        return false if slug == 'api/' or slug == 'creating-packages'
      end

      def additional_entries
        return [] unless ENTRIES_SLUG.include? slug
        if slug == 'creating-packages'
            css('h2').map do |node|
                name = node.content
                custom_parsed_uri = get_parsed_uri_by_name(name)
                id = node['id']
                [name, id, get_type, custom_parsed_uri , get_parent_uri, get_docset]
            end
        else
            css('#bowerrc-specification + ul a', '#commands + p + ul a').map do |node|
              name = node.content
              custom_parsed_uri = get_parsed_uri_by_name(name)
              id = node['href'].remove('#')
              [name, id, get_type, custom_parsed_uri , get_parent_uri, get_docset]
            end
        end
      end
    end
  end
end

module Docs
  class Bower
    class EntriesFilter < Docs::EntriesFilter
      ENTRIES_TYPE_BY_SLUG = {
        'api'    => 'Commands',
        'config' => '.bowerrc'
      }

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
        if slug.include? 'api'
            'Api'
        elsif slug.include? 'config'
            'Config'
        else
            'Guides'
        end
      end

      def additional_entries
        return [] unless type = ENTRIES_TYPE_BY_SLUG[slug]

        css('#bowerrc-specification + ul a', '#commands + p + ul a').map do |node|
          custom_parsed_uri = get_parsed_uri.sub('index', 'api') + node['href']
          [node.content, node['href'].remove('#'), get_type, custom_parsed_uri , get_parent_uri, get_docset]
        end
      end
    end
  end
end

module Docs
  class Requirejs
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
        'Guides'
      end

      def additional_entries
        return [] unless root_page?

        entries = []
        type = nil

        css('*').each do |node|
          if node.name == 'h2'
            type = node.content
          elsif node.name == 'h3' || node.name == 'h4'
            entries << [node.content, node['id'], type, get_parsed_uri.sub('index',node.content.downcase), get_parent_uri, get_docset]
          end
        end

        css('p[id^="config-"]').each do |node|
          next if node['id'].include?('note')
          entries << [node.at_css('strong').content, node['id'], 'Configuration Options', get_parsed_uri.sub('index',node.at_css('strong').content.downcase), get_parent_uri, get_docset]
        end

        entries
      end
    end
  end
end

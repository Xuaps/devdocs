module Docs
  class Underscore
    class EntriesFilter < Docs::EntriesFilter

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

      def additional_entries
        entries = []
        type = nil

        css('[id]').each do |node|
          # Module
          if node.name == 'h2'
            type = node.content.split.first
            next
          end

          # Method
          node.css('.header', '.alias b').each do |header|
            header.content.split(',').each do |name|
              custom_parsed_uri = get_parsed_uri_by_name(name)
              entries << [name, node['id'], type.downcase, custom_parsed_uri, get_parent_uri, get_docset]
            end
          end
        end

        entries
      end
    end
  end
end

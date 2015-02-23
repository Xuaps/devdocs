module Docs
  class Underscore
    class EntriesFilter < Docs::EntriesFilter

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/'
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
              entries << [name, node['id'], type, get_parsed_uri + name.downcase, get_parent_uri, get_docset]
            end
          end
        end

        entries
      end
    end
  end
end

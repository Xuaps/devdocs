module Docs
  class Underscore
    class EntriesFilter < Docs::EntriesFilter

      REPLACE_TYPE = {
        'functions' => 'function',
        'chaining' => 'function',
        'utility' => 'function',
        'collections' => 'collection',
        'arrays' => 'collection',
        'objects' => 'object'
      }
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

      def include_default_entry?
        return false
      end

      def additional_entries
        entries = []
        type = nil

        css('[id]').each do |node|
          # Module
          next if node['id'] == 'documentation'
          if node.name == 'h2'
            type = node['id']
            next
          end
          id = node['id']
          type = 'others' if not type
          # Method
          node.css('.header', '.alias b').each do |header|
            header.content.split(',').each do |name|
              custom_parsed_uri = get_parsed_uri_by_name(name)
              entries << [name, id, REPLACE_TYPE[type], custom_parsed_uri, get_parent_uri, get_docset]
            end
          end
        end

        entries
      end
    end
  end
end

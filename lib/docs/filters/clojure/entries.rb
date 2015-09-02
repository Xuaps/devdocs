module Docs
  class Clojure
    class EntriesFilter < Docs::EntriesFilter
      REPLACE_TYPES = {
        'clojure.test' => 'test',
        'clojure.pprint' => 'string',
        'clojure.string' => 'string',
        'clojure.reflect' => 'core',
        'clojure.repl' => 'core',
        'clojure.main' => 'core',
        'clojure.zip' => 'util',
        'clojure.core' => 'function',
        'clojure.template' => 'function',
        'clojure.set' => 'function',
        'clojure.walk' => 'function',
        'clojure.instant' => 'function',
        'clojure.java.shell' => 'function',
        'clojure.xml' => 'function',
        'clojure.edn' => 'function',
        'clojure.data' => 'data',
        'clojure.java.io' => 'io',
        'clojure.stacktrace' => 'io',
        'clojure.java.browse' => 'network',
        'clojure.java.javadoc' => 'documentation' }
      def get_name
        slug.remove('-api')
      end

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
        'namespace'
      end

      def get_type_by_name(name)
        REPLACE_TYPES[name]
      end

      def include_default_entry?
        return false if slug == 'api-index'
        return true
      end

      def additional_entries
        css(".toc-entry-anchor[href^='##{self.name}']").map do |node|
          name = node.content
          id = node['href'].remove('#')
          type = name == 'clojure.core' ? id.split('/').first : self.name
          custom_parsed_uri = get_parsed_uri_by_name(name.gsub("*", "_._"))
          [name, id, get_type_by_name(type) || type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

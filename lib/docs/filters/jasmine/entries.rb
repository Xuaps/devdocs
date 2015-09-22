module Docs
  class Jasmine
    class EntriesFilter < Docs::EntriesFilter

      AVOIDED_ENTRIES = ['changelog', 'license', 'browserify']

      REPLACE_TYPES = {
          'custom_matcher' => 'function',
          'custom_equality' => 'function',
          'custom_boot' => 'function',
          'custom_reporter' => 'function',
          'python_egg' => 'platforms',
          'ruby_gem' => 'platforms',
          'node' => 'platforms',
          'ajax' => 'platforms',
          'upgrading' => 'guide',
          'introduction' => 'guide',
          'focused_specs' => 'guide',
          'boot' => 'guide',
      }
      def get_name
        css('h1').first.content.remove('.js').strip
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name)
        end
        parsed_uri
      end

      def get_parsed_uri_by_name(name)
        parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        parsed_uri
      end

      def get_parent_uri
       'null'
      end

      def get_type
        REPLACE_TYPES[slug] || slug
      end

      def additional_entries
        entries = []
        type = 'others'
        css('h2','h3','h4').each do |node|
            name = node.content.strip
            next if AVOIDED_ENTRIES.include? name
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node.parent.parent['id'].remove('#'), get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end
        entries
      end
    end
  end
end

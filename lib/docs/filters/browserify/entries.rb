module Docs
  class Browserify
    class EntriesFilter < Docs::EntriesFilter

      AVOIDED_ENTRIES = ['changelog', 'license', 'browserify']

      REPLACE_TYPES = {
          'getting started' => 'others',
          'example' => 'guide',
          'install' => 'guide',
          'usage' => 'guide',
          'compatibility' => 'guide',
          'more examples' => 'guide',
          'methods' => 'method',
          'method' => 'method',
          'package.json' => 'package',
          'events' => 'event',
          'event' => 'event',
          'plugins' => 'tools',
          'list of source transforms' => 'package',
          'third-party tools' => 'tools',
          'external requires' => 'guide',
          'external source maps' => 'guide',
          'multiple bundles' => 'guide',
          'api example' => 'guide',
          'b.pipeline' => 'property',
          'browser field' => 'property',
          'browserify.transform' => 'property'
      }
      def get_name
        slug.split('/').last || 'Otro Index'
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
        'others'
      end

      def additional_entries
        entries = []
        type = 'others'
        css('h1 a', 'h2 a', 'h3 a', 'h4 a').each do |node|
            name = node.parent.content.strip
            next if AVOIDED_ENTRIES.include? name
            if name.include? '.on('
                type = 'event'
            elsif name.include? '('
                type = 'method'
            else
                type = name
            end
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['href'].remove('#'), REPLACE_TYPES[type], custom_parsed_uri, get_parent_uri, get_docset]
        end
        entries
      end
    end
  end
end

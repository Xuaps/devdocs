module Docs
  class Django
    class EntriesFilter < Docs::EntriesFilter

      def get_name
        at_css('h1').content.remove("\u{00b6}")
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
        case subpath
        when /\Atopics/
          'Guides'
        when /\Aintro/
          'Guides: Intro'
        when /\Ahowto/
          'Guides: How-tos'
        when /\Aref/
          'API'
        end
      end

      def additional_entries
        entries = []

        css('dl.function', 'dl.class', 'dl.method', 'dl.attribute').each do |node|
          next unless id = node.at_css('dt')['id']
          next unless name = id.dup.sub!('django.', '')

          path = name.split('.')
          type = "django.#{path.first}"
          type << ".#{path.second}" if %w(contrib db).include?(path.first)

          name.remove! 'contrib.'
          name << '()' if node['class'].include?('method') || node['class'].include?('function')

          entries << [name, id, type, custom_parsed_uri, get_parsed_uri, get_docset]
        end

        entries
      end

      def include_default_entry?
        at_css('#sidebar a[href="index"]')
      end
    end
  end
end

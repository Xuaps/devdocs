module Docs
  class Grunt
    class EntriesFilter < Docs::EntriesFilter

      def get_name
        if at_css('h1')
          name = at_css('h1').content
        else
          name = 'Grunt'
        end
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
          get_parsed_uri + '/' + self.urilized(name)
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        parsed_uri
      end

      def get_parent_uri
        'null'
      end

      def get_type
        'others'
      end

      def get_type_by_name(name)
        if name.downcase.include? 'config'
            'configuration'
        elsif name.downcase.include? 'event'
            'event'
        elsif name.downcase.include? 'fail'
            'error'
        elsif name.downcase.include? 'file'
            'file'
        else
          'others'
        end
      end

      def additional_entries
        return [] unless subpath.starts_with?('api')

        css('h3').each_with_object [] do |node, entries|
          name = node.content
          name.remove! %r{\s.+\z}

          next if name == self.name
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type_by_name(name), custom_parsed_uri, get_parsed_uri, get_docset]
        end
      end

    end
  end
end

module Docs
  class Phalcon
    class EntriesFilter < Docs::ReflyEntriesFilter
      def get_name
        (at_css('h1 > strong') || at_css('h1')).content.strip.remove('Phalcon\\')
      end
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
        parent_uri = 'null'
      end

      def get_type
        if slug.start_with?('reference')
          type = 'guide'
        elsif get_name.include? 'FETCH'
          type = 'constant'
        elsif get_name.downcase.include? 'class'
          type = 'class'
        elsif get_name.downcase.include? 'interface'
          type = 'interface'
        elsif get_name.include? 'FETCH'
          type = 'constant'
        elsif get_name.downcase.include? '::'
          type = 'method'
        else
          type = 'others'
        end
        type
      end

      def get_type_by_name(name)
        if slug.start_with?('reference')
          type = 'guide'
        elsif name.include? 'FETCH'
          type = 'constant'
        elsif name.downcase.include? 'class'
          type = 'class'
        elsif name.downcase.include? 'interface'
          type = 'interface'
        elsif name.downcase.include? '::'
          type = 'method'
        else
          type = 'others'
        end
        type

      end

      def additional_entries
        entries = []

        css('.method-signature').each do |node|
          next if node.content.include?('inherited from') || node.content.include?('protected ') || node.content.include?('private ')
          name = node.at_css('strong').content.strip
          next if name == '__construct' || name == '__toString'
          name.prepend "#{self.name}::"
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type_by_name(name), custom_parsed_uri, get_parent_uri, get_docset]
        end

        entries
      end
    end
  end
end

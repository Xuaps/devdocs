module Docs
  class Symfony
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        name = at_css('h1').content.strip
        name.remove! 'Symfony\\'
        name = name.split("\\").last
        name
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
        parent = at_css('h1').content.strip.downcase
        parent.remove! 'symfony\\'
        parent_list = parent.split("\\")
        parent_list.pop
        if parent_list.size>0
          parent_uri = context[:docset_uri] + '/' + parent_list.join('/')
        else
          parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        if css('.type')
          type = css('.type').first.content.strip.downcase
          type = 'others' if type == 'trait'
        else
          type = 'others'
        end
        type
      end

      def namespace
        @namespace ||= begin
          path = slug.remove('Symfony/').remove(/\/\w+?\z/).split('/')
          upto = 1
          upto = 2 if path[1] == 'Form' && path[2] == 'Extension'
          upto = 2 if path[1] == 'HttpFoundation' && path[2] == 'Session'
          path[0..upto].join('\\')
        end
      end

      IGNORE_METHODS = %w(get set)

      def additional_entries
        return [] if initial_page?
        return [] if type == 'Exceptions'
        return [] if self.name.include?('Legacy') || self.name.include?('Loader')

        entries = []
        base_name = self.name.remove(/\(.+\)/).strip

        css('h3[id^="method_"]').each do |node|
          next if node.at_css('.location').content.start_with?('in')

          name = node['id'].remove('method_')
          next if name.start_with?('_') || IGNORE_METHODS.include?(name)

          name.prepend "#{base_name}::"
          name << "() (#{namespace})"
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end

        entries.size > 1 ? entries : []
      end

      def include_default_entry?
        !initial_page?
      end
    end
  end
end

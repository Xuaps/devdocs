module Docs
  class Elixir
    class EntriesFilter < Docs::ReflyEntriesFilter
      REPLACE_TYPES = {
        'Kernel' => 'function',
        'Access' => 'function',
        'Base' => 'function',
        'Atom' => 'function',
        'Bitwise' => 'operator',
        'API' => 'api',
        'Application' => 'module',
        'ExUnit' => 'module',
        'IEx' => 'module',
        'Agent' => 'module',
        'Behaviour' => 'module',
        'Code' => 'function',
        'Enum' => 'data'
      }
      def get_name
        at_css('h1').content.split(' ').first.strip
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
        case at_css('h1 small').try(:content)
        when 'exception'
          'exception'
        when 'protocol'
          'others'
        else
          REPLACE_TYPES[get_name.split('.').first] || 'others'
        end

      end

      def additional_entries
        return [] if type == 'exception'

        css('.detail-header .signature').map do |node|
          id = node.parent['id']
          name = node.content.strip
          name.remove! %r{\(.*\)}
          name.remove! 'left '
          name.remove! ' right'
          name.sub! 'sigil_', '~'
          if name == '::'
            name.prepend 'unary '
          end

          unless node.parent['class'].end_with?('macro') || self.name.start_with?('Kernel')
            name.prepend "#{self.name}."
            name << " (#{id.split('/').last})"
          end
          custom_parsed_uri = get_parsed_uri_by_name(name)
          [name, id, get_type || 'others', custom_parsed_uri, get_parsed_uri, get_docset]
        end
      end
    end
  end
end

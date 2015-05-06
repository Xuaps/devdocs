module Docs
  class Moment
    class EntriesFilter < Docs::EntriesFilter
      IGNORE_IDS = %w(
        i18n-loading-into-nodejs
        i18n-loading-into-browser
        i18n-adding-locale
        i18n-getting-locale)

      REPLACE_TYPES = {
        'Customize'  => 'function',
        'Manipulate' => 'method',
        'Display'    => 'view',
        'Get + Set'  => 'method',
        'Durations'  => 'method',
        'Utilities'  => 'function',
        'Query'      => 'method',
        'Parse'      => 'function',
        'i18n'       => 'function'

      }
      def get_name
        'Index'
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
        'null'
      end

      def get_type
        'others'
      end

      def additional_entries
        entries = []
        type = nil

        css('[id]').each do |node|
          if node.name == 'h2'
            type = node.content
            next
          end

          next unless node.name == 'h3'
          next if IGNORE_IDS.include?(node['id'])

          if node['id'] == 'utilities-invalid' # bug fix
            name = 'moment.invalid()'
          elsif %w(Display Durations Get\ +\ Set i18n Manipulate Query Utilities).include?(type) ||
                %w(parsing-is-valid parsing-parse-zone parsing-unix-timestamp parsing-utc customization-relative-time-threshold).include?(node['id'])
            name = node.next_element.content[/moment(?:\(.*?\))?\.(?:duration\(\)\.)?\w+/]
            name.sub! %r{\(.*?\)\.}, '.'
            name << '()'
          elsif type == 'Customize'
            name = node.next_element.content[/moment.locale\(.+?\{\s+(\w+)/, 1]
            name.prepend 'Locale.'
          else
            name = node.content.strip
            name.remove! %r{\s[\d\.]+[\s\+]*\z} # remove version number
            name.remove! %r{\s\(.+\)\z}  # remove parenthesis
            name.prepend 'Parse: ' if type == 'Parse'
          end
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], REPLACE_TYPES[type], custom_parsed_uri, get_parent_uri, get_docset]
        end

        entries
      end
    end
  end
end

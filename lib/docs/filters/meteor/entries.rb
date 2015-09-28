module Docs
  class Meteor
    class EntriesFilter < Docs::ReflyEntriesFilter
      REPLACE_TYPES = {
        'Check' => 'function',
        'Command line' => 'core',
        'Core' => 'core',
        'EJSON' => 'function',
        'mobile-config.js' => 'platforms',
        'Packages' => 'package',
        'package.js' => 'package',
        'Tracker' => 'function',
        'Passwords' => 'function',
        'Assets' => 'io',
        'Accounts' => 'function',
        'Templates' => 'function',
        'Blaze' => 'function',
        'Timers' => 'function',
        'Collections' => 'function',
        'Concepts' => 'guide',
        'Publish and subscribe' => 'guide',
        'Server connections' => 'network',
        'Email' => 'network',
        'HTTP' => 'network',
        'Methods' => 'method',
        'ReactiveVar' => 'object'
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
        type = nil

        at_css('.full-api-toc').element_children.each_with_object [] do |node, entries|
          link = node.at_css('a')
          next unless link

          target = link['href'].remove('#/full/')
          name = node.content
          custom_parsed_uri = get_parsed_uri_by_name(name)
          case node.name
          when 'h1'
            type = node.content.strip
          when 'h2'
            if type == 'Concepts'
              entries << [name, target, REPLACE_TYPES[type] || type || 'others', custom_parsed_uri, get_parent_uri, get_docset]
            else
              type = node.content.strip
            end
          when 'h3', 'h4'
            entries << [name, target, REPLACE_TYPES[type] || type || 'others', custom_parsed_uri, get_parent_uri, get_docset]
          end
        end
      end
    end
  end
end

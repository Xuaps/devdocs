module Docs
  class Npm
    class EntriesFilter < Docs::ReflyEntriesFilter
      REPLACED_TYPES = {
        'Getting Started' => 'guide',
        'Using npm' => 'guide',
        'Using npm programmatically' => 'function',
        'package.json' => 'others',
        'Configuring npm' => 'configuration',
        'Config' => 'configuration',
        'CLI Commands' => 'command',
      }
      def get_name
        if slug.start_with?('api') && at_css('pre').content =~ /\A\s*npm\.([\w\-]+\.)*[\w\-]+/
          name = $&.strip
        elsif at_css('nav > section.active a.active')
          name = at_css('nav > section.active a.active').content
        else
          name = 'Index'
        end

        name << ' (CLI)' if slug.start_with?('cli')
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
        parent_uri = context[:docset_uri]
        xpath('//nav[@class="crumbs"]//a/text()').each do |node|
           link = node.content.strip
           if not EXCLUDED_PATH.include? link
              parent_uri += '/' + self.urilized(link)
           end
        end
        if parent_uri == context[:docset_uri]
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        if slug == 'files/package.json'
          type = 'package.json'
        elsif slug == 'misc/config'
          type = 'Config'
        elsif at_css('nav > section.active > h2')
            type = at_css('nav > section.active > h2').content.strip
        else
            type = 'others'
        end
        REPLACED_TYPES[type] || type
      end

      def additional_entries
        case slug
        when 'files/package.json'
          css('#page > h2[id]').each_with_object [] do |node, entries|
            next if node.content =~ /\A[A-Z]/
            custom_parsed_uri = get_parsed_uri_by_name("package.json: #{node.content}")
            entries << ["package.json: #{node.content}", node['id'], get_type, custom_parsed_uri, get_parsed_uri, get_docset]
          end
        when 'misc/config'
          css('#config-settings ~ h3[id]').map do |node|
            custom_parsed_uri = get_parsed_uri_by_name("config: #{node.content}")
            ["config: #{node.content}", node['id'], 'configuration', custom_parsed_uri, get_parsed_uri, get_docset]
          end
        else
          []
        end
      end
    end
  end
end
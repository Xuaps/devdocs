module Docs
  class Phaser
    class EntriesFilter < Docs::ReflyEntriesFilter
      REPLACE_TYPES = {
        'gameobjects' => 'object',
        'geom'        => 'drawing',
        'tilemap'     => 'view',
        'net'         => 'network',
        'tween'       => 'effect',
        'pixi'        => 'drawing',
        'methods'     => 'method',
        'animation'   => 'effect',
        'sound'       => 'io',
        'core'        => 'class',
        'loader'      => 'class',
        'system'      => 'class',
        'input'       => 'io',
        'math'        => 'function',
        'global'      => 'others',
        'utils'       => 'class',
        'particles'   => 'effect',
        'physics'     => 'effect',
        'members'      => 'class'
      }

      def get_name
        name = at_css('.title-frame h1').content
        name.remove!('Phaser.')
        name.remove!('PIXI.')
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
          context[:docset_uri] + '/' + self.urilized(name.strip)
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
          parent_uri
      end

      def get_type
        src = at_css('.container-overview .details > .tag-source > a')

        if src
          src = src.content.split('/').first
          return REPLACE_TYPES[src.downcase] || src.capitalize
        end

        'others'
      end

      def additional_entries
        entries = []

        %w(members methods).each do |type|
          css("##{type} h4.name").each do |node|
            sig = node.at_css('.type-signature')
            next if node.parent.parent.at_css('.inherited-from') || (sig && sig.content.include?('internal'))
            sep = sig && sig.content.include?('static') ? '.' : '#'
            name = "#{self.name}#{sep}#{node['id']}#{'()' if type == 'methods'}"
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], REPLACE_TYPES[type] || type, custom_parsed_uri, get_parent_uri, get_docset]
          end
        end

        entries
      end
    end
  end
end

module Docs
  class Sinon
    class EntriesFilter < Docs::EntriesFilter

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
        subpath = *path.split('/')
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            parent_uri = 'null'
        end
      end

      def get_type
          'others'
      end

      def get_type_by_name(typename)
          if typename.include? 'Fake timers' or typename.include? 'Fake XMLHttpRequest' or typename.include? 'Sandboxes' or typename.include? 'Spies'
              'function'
          elsif typename.include? 'Assertions'
              'assertion'
          elsif typename.include? 'Utilities'
              'utils'
          elsif typename.include? 'Stubs'
              'stubs'
          else
              'others'
          end
      end

      def include_default_entry?
        return false
      end

      def additional_entries
        entries = []
        type = config = nil
        entries << ['Spi API','spyprops','others','/sinonjs/spiapi', 'null', 'SinonJS']
        css('*').each do |node|
          if node.name == 'h2'
            config = false
            type = node.content.strip
            type.remove! 'Test '
            type.remove! 'Sinon.JS '
            type = type[0].upcase + type.from(1)
            id = type.parameterize
            node['id'] = id
            custom_parsed_uri = get_parsed_uri_by_name(type)
            entries << [type, id, 'others', custom_parsed_uri, get_parent_uri, get_docset]
          elsif node.name == 'h3' && node.content.include?('sinon.config')
            config = true
          elsif node.name == 'dl'
            node.css('dt > code').each do |code|
              name = code.content.strip
              name.sub! %r{\(.*\);?}, '()'
              name.sub! %r{\Aserver.(\w+)\s=.*\z}, 'server.\1'
              name.remove! '`'
              name.remove! %r{\A.+?\=\s+}
              name.remove! %r{\A\w+?\s}
              name.prepend 'sinon.config.' if config
              next if name =~ /\s/
              next if entries.any? { |entry| entry[0].casecmp(name) == 0 }

              id = name.parameterize.remove 'sinon-'
              code.parent['id'] = id
              custom_parsed_uri = get_parsed_uri_by_name(name)
              entries << [name, id, get_type_by_name(type), custom_parsed_uri, get_parent_uri, get_docset]
            end
          end
        end

        entries
      end
    end
  end
end

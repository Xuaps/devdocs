module Docs
  class Nokogiri2
    class EntriesFilter < Docs::EntriesFilter
      REPLACED_NAMES = {
        'README.rdoc' => 'README'
      }
      EXCLUDED_PATH = ['Libraries']
      def get_name
        if REPLACED_NAMES.include? slug
          name = REPLACED_NAMES[slug]
        elsif at_css('h1')
          name = at_css('h1').content.strip
          if name.index('::')
            name = name.split('::').last
          end
        else
          name = slug
        end
        name.remove! 'Module: '
        name.remove! 'Class: '
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
        xpath('//div[@id="menu"]//a/text()').each do |node|
           link = node.content.strip
           if not EXCLUDED_PATH.include? link and !link.start_with? 'Index'
              parent_uri += '/' + self.urilized(link)
           end
        end
        if parent_uri == context[:docset_uri]
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        if at_css('h1')
          name = at_css('h1').content.strip
        else
          name = 'others'
        end
        if name.start_with? 'Module'
          type = 'module'
        elsif name.start_with? 'Class'
          type = 'class'
        else
          type = 'others'
        end
        type
      end

      def additional_entries
        return [] if type == 'Miscellaneous'

        klass = nil
        entries = []

        css('> [id]').each do |node|
          next if node.name == 'h1'

          klass = nil if node.name == 'h2'
          name = node.content.strip
          custom_parsed_uri = get_parsed_uri_by_name(name)
          # Skip constructors
          if name.start_with? 'new '
            next
          end

          # Ignore most global objects (found elsewhere)
          if type == 'Global Objects'
            entries << [name, node['id'], 'object', custom_parsed_uri, get_parsed_uri, get_docset] if name.start_with?('_') || name == 'global'
            next
          end

          # Classes
          if name.gsub! 'Class: ', ''
            name.remove! 'events.' # EventEmitter
            klass = name
            entries << [name, node['id'], 'class', custom_parsed_uri, get_parsed_uri, get_docset]
            next
          end

          # Events
          if name.sub! %r{\AEvent: '(.+)'\z}, '\1'
            name << " event (#{klass || type})"
            entries << [name, node['id'], 'event', custom_parsed_uri, get_parsed_uri, get_docset]
            next
          end

          name.gsub! %r{\(.*?\);?}, '()'
          name.gsub! %r{\[.+?\]}, '[]'
          name.remove! 'assert(), ' # assert/assert.ok

          # Skip all that start with an uppercase letter ("Example") or include a space ("exports alias")
          next unless (name.first.upcase! && !name.include?(' ')) || name.start_with?('Class Method')

          # Differentiate server classes (http, https, net, etc.)
          name.sub!('server.') { "#{(klass || 'https').sub('.', '_').downcase!}." }
          # Differentiate socket classes (net, dgram, etc.)
          name.sub!('socket.') { "#{klass.sub('.', '_').downcase!}." }

          name.remove! 'Class Method:'
          name.sub! 'buf.',     'buffer.'
          name.sub! 'buf[',     'buffer['
          name.sub! 'child.',   'childprocess.'
          name.sub! 'decoder.', 'stringdecoder.'
          name.sub! 'emitter.', 'eventemitter.'
          name.sub! %r{\Arl\.}, 'interface.'
          name.sub! 'rs.',      'readstream.'
          name.sub! 'ws.',      'writestream.'

          # Skip duplicates (listen, connect, etc.)
          unless name == entries[-1].try(:first) || name == entries[-2].try(:first)
            entries << [name, node['id'], get_type, custom_parsed_uri, get_parsed_uri, get_docset]
          end
        end

        entries
      end
    end
  end
end

module Docs
  class Node
    class EntriesFilter < Docs::EntriesFilter
      REPLACE_NAMES = {
        'debugger' => 'Debugger',
        'addons'   => 'C/C++ Addons',
        'modules'  => 'module' }

      REPLACE_TYPES = {
        'Assert'                 => 'function',
        'Addons'                 => 'others',
        'Debugger'               => 'others',
        'Cluster'                => 'others',
        'Modules'                => 'others',
        'Util'                   => 'others',
        'Path'                   => 'core',
        'File System'            => 'core',
        'os'                     => 'core',
        'Child Process'          => 'core',
        'Process'                => 'core',
        'Console'                => 'core',
        'TTY'                    => 'core',
        'HTTPS'                  => 'network',
        'HTTP'                   => 'network',
        'TLS (SSL)'              => 'network',
        'UDP / Datagram Sockets' => 'network',
        'URL'                    => 'network',
        'Net'                    => 'network',
        'Domain'                 => 'network',
        'DNS'                    => 'network',
        'Smalloc'                => 'function',
        'Zlib'                   => 'function',
        'StringDecoder'          => 'function',
        'Timer'                  => 'function',
        'Timers'                 => 'function',
        'Crypto'                 => 'function',
        'REPL'                   => 'function',
        'Query String'           => 'function',
        'Executing JavaScript'   => 'function',
        'Readline'               => 'function',
        'Stream'                 => 'data',
        'Buffer'                 => 'data',
        'Punycode'               => 'data',
        'Events'                 => 'event',
        'Global Objects'         => 'object'}

      IGNORE_DEFAULT_ENTRY = %w(globals timers domain buffer)

      def include_default_entry?
        !IGNORE_DEFAULT_ENTRY.include?(slug)
      end

      def get_name
        REPLACE_NAMES[slug] || slug
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
          context[:docset_uri] + '/' + self.urilized(name)
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
        subpath = *path.split('/')
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            parent_uri = 'null'
        end
      end

      def get_type
        type = at_css('h1').content.strip
        REPLACE_TYPES[type] || "#{type.first.upcase}#{type[1..-1]}"
      end

      def additional_entries
        path = get_path + '.html'
        klass = nil
        entries = []

        css('> [id]').each do |node|
          next if node.name == 'h1'

          klass = nil if node.name == 'h2'
          name = node.content.strip

          # Skip constructors
          if name.start_with? 'new '
            next
          end

          # Ignore most global objects (found elsewhere)
          if type == 'Global Objects'
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset] if name.start_with?('_') || name == 'global'
            next
          end

          # Classes
          if name.gsub! 'Class: ', ''
            name.remove! 'events.' # EventEmitter
            klass = name
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
            next
          end

          # Events
          if name.sub! %r{\AEvent: '(.+)'\z}, '\1'
            name << " event (#{klass || get_type})"
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
            next
          end

          name.gsub! %r{\(.*?\)}, '()'
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
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
          end
        end
        entries
      end
    end
  end
end

module Docs
  class Python2
    class EntriesFilter < Docs::EntriesFilter
      REPLACE_TYPES = {
        'compiler package'                        => 'function',
        'Cryptographic'                           => 'function',
        'Custom Interpreters'                     => 'function',
        'SGI IRIX'                                => 'function',
        'Numeric & Mathematical'                  => 'type',
        'String'                                  => 'type',
        'Data Types'                              => 'type',
        'Graphical User Interfaces with Tk'       => 'view',
        'Multimedia'                              => 'view',
        'Structured Markup Processing Tools'      => 'view',
        'Internet Data Handling'                  => 'network',
        'Internet Protocols & Support'            => 'network',
        'Interprocess Communication & Networking' => 'network',
        'Internationalization'                    => 'language',
        'Language'                                => 'language',
        'File & Directory Access'                 => 'io',
        'Importing'                               => 'io',
        'Data Compression & Archiving'            => 'data',
        'Data Persistence'                        => 'data',
        'Generic Operating System'                => 'core',
        'Runtime'                                 => 'core',
        'Operating System'                        => 'core',
        'MacOSA'                                  => 'core',
        'Unix'                                    => 'core',
        'Optional Operating System'               => 'core',
        'MS Windows'                              => 'core',
        'SunOS'                                   => 'core',
        'Program Frameworks'                      => 'core',
        'Built-in Exceptions'                     => 'exception',
        'Development Tools'                       => 'others',
        'Debugging & Profiling'                   => 'others',
        'File Formats'                            => 'others',
        'Restricted Execution'                    => 'others',
        'Software Packaging & Distribution'       => 'others'
      }

      def get_name
        name = at_css('h1').content
        name.remove! %r{\A[\d\.]+ } # remove list number
        name.remove! "\u{00B6}" # remove pilcrow sign
        name.remove! %r{ [\u{2013}\u{2014}].+\z} # remove text after em/en dash
        name.remove! 'Built-in'
        name.strip!
        name
      end
      
      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
          context[:docset_uri] + '/' + self.urilized(name)
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        parsed_uri
      end

      def get_parent_uri
        parent_uri = 'null'
        parent_uri
      end

      def get_type
        return 'others' if slug.start_with? 'library/logging'

        if at_css('.related a[accesskey="U"]')
          type = at_css('.related a[accesskey="U"]').content
        else
          type = 'others'
        end

        if type == 'The Python Standard Library'
          type = at_css('h1').content
          if type.include? 'Functions'
              type = 'function'
          elsif type.include? 'Built-in Types'
              type = 'type'
          elsif type.include? 'Built-in Constants'
              type = 'data'
          end
        elsif type.include?('I/O') || %w(select selectors).include?(name)
          type = 'io'
        elsif type.start_with? '18'
          type = 'network'
        elsif type.include? 'Mac'
          type = 'core'
        end

        type.remove! %r{\A\d+\.\s+} # remove list number
        type.remove! "\u{00b6}" # remove paragraph character
        type.sub! ' and ', ' & '
        [' Services', ' Modules', ' Specific', 'Python '].each { |str| type.remove!(str) }

        REPLACE_TYPES[type] || type
      end

      def include_default_entry?
        !(at_css('.body > .section:only-child > .toctree-wrapper:last-child') && !type.in?(%w(Language Superseded SunOS))) || slug == 'library/index'
      end

      def additional_entries
        return [] if !include_default_entry? || name == 'errno'
        clean_id_attributes
        entries = []

        css('.class > dt[id]', '.exception > dt[id]', '.attribute > dt[id]').each do |node|
          name = node['id']
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type, custom_parsed_uri, get_parsed_uri, get_docset]
        end

        css('.data > dt[id]').each do |node|
          if node['id'].split('.').last.upcase! # skip constants
            name = node['id']
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type, custom_parsed_uri, get_parsed_uri, get_docset]
          end
        end

        css('.function > dt[id]', '.method > dt[id]', '.classmethod > dt[id]').each do |node|
          name = node['id'] + '()'
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type, custom_parsed_uri, get_parsed_uri, get_docset]
        end

        entries
      end

      def clean_id_attributes
        css('.section > .target[id]').each do |node|
          if dt = node.at_css('+ dl > dt')
            dt['id'] ||= node['id'].remove(/\w+\-/)
          end
          node.remove
        end
      end
    end
  end
end
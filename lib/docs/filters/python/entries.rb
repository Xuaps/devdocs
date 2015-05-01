module Docs
  class Python
    class EntriesFilter < Docs::EntriesFilter

      REPLACE_TYPES = {
        'Runtime'                                 => 'core',
        'Cryptographic'                           => 'function',
        'Custom Interpreters'                     => 'function',
        'Structured Markup Processing Tools'      => 'function',
        'Data Compression & Archiving'            => 'data',
        'Internet Data'                           => 'data',
        'Generic Operating System'                => 'core',
        'Program Frameworks'                      => 'core',
        'Graphical User Interfaces with Tk'       => 'view',
        'Internet Data Handling'                  => 'network',
        'Internet Protocols & Support'            => 'network',
        'Interprocess Communication & Networking' => 'network',
        'Binary Data'                             => 'data',
        'array'                                   => 'type',
        'Built-in Types'                          => 'type',
        'Software Packaging & Distribution'       => 'others',
        'File & Directory Access'                 => 'others',
        'Data Types'                              => 'type'}

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
        type = ''
        type = at_css('.related a[accesskey="U"]').content if at_css('.related a[accesskey="U"]')

        if type == 'The Python Standard Library'
          type = at_css('h1').content
          if type.include? 'Constants'
              type = 'data'
          elsif type.include? 'Exceptions'
              type = 'class'
          elsif type.include? 'Functions'
              type = 'function'
          end
        elsif type.include?('I/O') || %w(select selectors).include?(get_name)
          type = 'io'
        elsif type.start_with? '19'
          type = 'network'
        elsif type.downcase.include? 'data'
          type = 'data'
        elsif type.include? 'Numeric'
          type = 'function'
        elsif type.include? 'Processing'
          type = 'function'
        elsif type.include? 'Debugging'
          type = 'others'
        elsif type.include? 'Directory'
          type = 'io'
        elsif type.include? 'Unix'
          type = 'core'
        elsif type.include? 'Functional'
          type = 'function'
        elsif type.include? 'Internationalization'
          type = 'language'
        elsif type.include? 'Importing'
          type = 'io'
        elsif type.include? 'Multimedia'
          type = 'view'
        elsif type.include? 'Logging'
          type = 'others'
        elsif type.include? 'Logging'
          type = 'others'
        elsif type.include? 'Windows'
          type = 'core'
        elsif type.include? 'File'
          type = 'others'
        elsif type.include? 'Constants'
          type = 'data'
        elsif type.include? 'Concurrent'
          type = 'core'
        elsif type.include? 'Tools'
          type = 'class'
        elsif type.include? 'Functions'
          type = 'function'
        elsif type.include? 'Exceptions'
          type = 'exception'
        end

        type.remove! %r{\A\d+\.\s+} # remove list number
        type.remove! "\u{00b6}" # remove paragraph character
        type.sub! ' and ', ' & '
        [' Services', ' Modules', ' Specific', 'Python '].each { |str| type.remove!(str) }

        REPLACE_TYPES[type] || type
      end

      def include_default_entry?
        !at_css('.body > .section:only-child > .toctree-wrapper:last-child') && !type.in?(%w(Language Superseded))
      end

      def additional_entries
        return [] if root_page? || !include_default_entry? || get_name == 'errno'
        clean_id_attributes
        entries = []

        css('.class > dt[id]', '.exception > dt[id]', '.attribute > dt[id]').each do |node|
          name = node['id'].remove(/\w+\-/)
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end

        css('.data > dt[id]').each do |node|
          if node['id'].split('.').last.upcase! # skip constants
            name = node['id'].remove(/\w+\-/)
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
          end
        end

        css('.function > dt[id]', '.method > dt[id]', '.classmethod > dt[id]').each do |node|
          name = node['id'].remove(/\w+\-/)
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name + '()', node['id'], get_type, custom_parsed_uri, get_parsed_uri, get_docset]
        end

        entries
      end

      def clean_id_attributes
        css('.section > .target[id]').each do |node|
          if dt = node.at_css('+ dl > dt')
            dt['id'] ||= node['id']
          end
          #node.remove
        end
      end
    end
  end
end

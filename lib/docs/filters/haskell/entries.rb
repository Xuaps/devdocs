module Docs
  class Haskell
    class EntriesFilter < Docs::EntriesFilter
      #NULL_PARENT_URIs = %w(haskell98-2.0.0.3)
      IGNORE_ENTRIES_PATHS = %w(
        bytestring-0.10.4.0/Data-ByteString-Lazy.html
        bytestring-0.10.4.0/Data-ByteString-Char8.html
        bytestring-0.10.4.0/Data-ByteString-Lazy-Char8.html
        array-0.5.0.0/Data-Array-IArray.html
        containers-0.5.5.1/Data-IntMap-Lazy.html
        containers-0.5.5.1/Data-Map-Lazy.html
        unix-2.7.0.1/System-Posix-Files-ByteString.html
        filepath-1.3.0.2/System-FilePath-Windows.html
        transformers-0.3.0.0/Control-Monad-Trans-RWS-Lazy.html
        transformers-0.3.0.0/Control-Monad-Trans-Writer-Lazy.html
        base-4.7.0.0/GHC-Conc-Sync.html
        base-4.7.0.0/GHC-IO-Encoding-UTF32.html
        unix-2.7.0.1/System-Posix-Terminal-ByteString.html)

      def get_name
        if at_css('#module-header .caption')
          at_css('#module-header .caption').content.strip
        else
          'Haskell'
        end
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
        name = get_name
        if name.include? 'Data'
             'data'
        elsif %w(Complex Array Char Numeric Maybe).include? name or name.include? 'Foreign'
             'type'
        elsif %w(List Prelude IO Ratio Random Debug.Trace).include? name or name.include? 'Text' or name.include? 'Trace' or name.include? 'Control'
             'function'
        elsif name.include? 'GHC' or name.include? 'Compiler' or name.include? 'System' or name.include? 'GHC'
             'module'
        elsif name.include? 'Language'
             'language'
        elsif name.include? 'Ix'
             'class'
        else
            'others'
        end

      end

      def additional_entries
        return [] if IGNORE_ENTRIES_PATHS.include?(subpath)
        css('#synopsis > ul > li').each_with_object [] do |node, entries|
          link = node.at_css('a')
          next unless link['href'].start_with?('#')
          name = node.content.strip
          name.remove! %r{\A(?:module|data|newtype|class|type family m|type)\s+}
          name.sub! %r{\A\((.+?)\)}, '\1'
          #name.sub!(/ (?:\:\: (\w+))?.+\z/) { |_| $1 ? " (#{$1})" : '' }
          next if name == self.name
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, link['href'].remove('#'),get_type, custom_parsed_uri, get_parsed_uri, get_docset]
        end
      end

      def include_default_entry?
        true #at_css('#synopsis > ul > li')
      end
    end
  end
end

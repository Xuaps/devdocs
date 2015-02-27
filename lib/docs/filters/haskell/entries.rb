module Docs
  class Haskell
    class EntriesFilter < Docs::EntriesFilter
      NULL_PARENT_URIs = %w(haskell98-2.0.0.3)
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
        at_css('#module-header .caption').content.strip
      end

      def filter_name(name,link)
        subpath = *path.split('/')
        subpath[subpath.size-1] + '.' + link.remove('#').remove('v:-33--33-').remove('t:') + ' ' + name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + path.sub('haskell98-2.0.0.3', '')
        parsed_uri
      end

      def get_parent_uri
        subpath = *path.split('/')
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
            if NULL_PARENT_URIs.include? subpath[subpath.size-1]
               parent_uri = 'null'
            end
        else
            parent_uri = 'null'
        end
      end

      def get_type
        %w(System.Posix System.Win32 Control.Monad).each do |type|
          return type if name.start_with?(type)
        end

        if name.start_with?('Data')
          name.split('.')[0..1].join('.')
        else
          name.split('.').first
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
          name.sub!(/ (?:\:\: (\w+))?.+\z/) { |_| $1 ? " (#{$1})" : '' }
          next if name == self.name
          entries << [name, link['href'].remove('#'),get_type, get_parsed_uri, get_parent_uri, get_docset]
        end
      end

      def include_default_entry?
        at_css('#synopsis > ul > li')
      end
    end
  end
end

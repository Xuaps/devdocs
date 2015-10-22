module Docs
  class Perl
    class EntriesFilter < Docs::ReflyEntriesFilter

      EXCLUDED_PATH = ['Language reference', 'Home', 'Index', 'History / Changes', 'Licence']
      REPLACE_NAMES = {
        'Perl functions A-Z' => 'Functions'
      }
      def get_name
        name = at_css('h1').content.strip
        REPLACE_NAMES[name] || name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
          get_parsed_uri + '/' + self.urilized(name)
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name.remove '%')
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name.remove '%')
        end
        parsed_uri
      end

      def get_parent_uri
        parent_uri = context[:docset_uri]
        xpath('//div[@id="breadcrumbs"]//a/text()').each do |node|
           link = node.content.strip
           if not EXCLUDED_PATH.include? link and !link.starts_with? 'Core modules'
              parent_uri += '/' + self.urilized(link)
           end
        end
        if parent_uri == context[:docset_uri]
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        parsed_uri = get_parsed_uri
        name = get_name
        if parsed_uri.include? 'functions' or parsed_uri.include? 'math' or parsed_uri.include? 'archive'
          'function'
        elsif parsed_uri.include? 'perlop'
          'operator'
        elsif parsed_uri.include? 'platform_specific'
          'platform'
        elsif parsed_uri.include? 'perlvar'
          'variable'
        elsif parsed_uri.include? 'perlvar'
          'variable'
        elsif name.include? '::' or name== 'B'
          'object'
        elsif parsed_uri.include? 'perlform'
          'view'
        elsif parsed_uri.include? 'pragma'
          'pragma'
        elsif parsed_uri.include? 'interface'
          'interface'
        elsif parsed_uri.include? 'utilities'
          'util'
        elsif parsed_uri.include? 'module'
          'module'
        elsif parsed_uri.include? 'io--' or parsed_uri.include? 'file'
          'io'
        else
          'others'
        end
      end

      def include_default_entry?
        return false if slug.starts_with? 'perl' and slug.end_with? 'delta'
        return true
      end

      def additional_entries
        entries = []
        if !slug.include? 'index'
          css('h2').each do |node|
            custom_name = node.content.strip
            id = custom_name.tr(' ','-').remove '%'
            custom_parsed_uri = get_parsed_uri_by_name(custom_name)
            entries << [custom_name, id, get_type, custom_parsed_uri, get_parsed_uri, get_docset]
          end
        end
        entries
      end
    end
  end
end

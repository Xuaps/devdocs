module Docs
  class C
    class EntriesFilter < Docs::EntriesFilter
      ADDITIONAL_NAMES = {
        'Conditional inclusion' => %w(if else elif ifdef ifndef endif).map { |s| "##{s} directive" },
        'Function specifiers' => ['inline specifier', '_Noreturn specifier'] }

      REPLACE_NAMES = {
        'Error directive' => '#error directive',
        'Filename and line information' => '#line directive',
        'Implementation defined behavior control' => '#pragma directive',
        'Replacing text macros' => '#define directive',
        'Source file inclusion' => '#include directive',
        'Warning directive' => '#warning directive' }

      def get_name
        name = at_css('#firstHeading').content.strip
        name.remove! 'C keywords: '
        name.remove! %r{\s\(.+\)}
        name = name.split(',').first
        REPLACE_NAMES[name] || name
      end

      def get_docset
        docset = context[:root_title]
        docset
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
        if type = at_css('.t-navbar > div:nth-child(4) > :first-child').try(:content)
          type.strip!
          type.remove! ' library'
          type.remove! ' utilities'
          type
        end
      end

      def additional_entries
        names = at_css('#firstHeading').content.split(',')[1..-1]
        names.concat ADDITIONAL_NAMES[name] || []
        names.map { |name| [name, nil, get_type, get_parsed_uri, get_parent_uri, get_docset] }
      end

      def include_default_entry?
        at_css '.t-navbar > div:nth-child(4) > a'
      end
    end
  end
end

module Docs
  class C
    class EntriesFilter < Docs::EntriesFilter
      EXCLUDED_PATH = ['C']

      REPLACE_PARENTS = {
        }

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
        if at_css('.t-navbar-head >.selflink')
            name = at_css('.t-navbar-head >.selflink').content.strip
        else
            name = at_css('#firstHeading').content.strip
        end
        name.remove! 'C keywords: '
        name.remove! %r{\s\(.+\)}
        name = name.split(',').first
        REPLACE_NAMES[name] || name
      end

      def get_custom_name(customname)
        customname.remove! 'C keywords: '
        customname.remove! %r{\s\(.+\)}
        customname = REPLACE_NAMES[customname] || customname
        customname
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(customname)
        customname.remove! 'C keywords: '
        customname.remove! %r{\s\(.+\)}
        customname = REPLACE_NAMES[customname] || customname
        customparsed_uri = get_parsed_uri + '/' + self.urilized(customname)
        customparsed_uri
      end

      def get_parsed_uri
        if parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = parent_uri + '/' + self.urilized(get_name)
        end
        parsed_uri
      end

      def get_parent_uri
        parent_uri = context[:docset_uri]
        if xpath('//*[@class="t-navbar"]').size >= 2
            xpath('//*[@class="t-navbar"]').first.remove
        end
        xpath('//div[@class="t-navbar-head"]/a').each do |node|
           link = node.content.strip
           if not EXCLUDED_PATH.include? link and link != get_name
              parent_uri += '/' + self.urilized(link)
           end
        end
        if parent_uri == context[:docset_uri]
            parent_uri = 'null'
        end
        REPLACE_PARENTS.each do  |key, value|
           parent_uri.sub! key, value
        end
        parent_uri
      end

      def get_type
        if slug.include? 'keyword'
            type = 'language'
        elsif slug.include? 'container'
            type = 'operator'
        elsif slug.include? 'type'
            type = 'type'
        elsif slug.include? 'utility'
            type = 'function'
        elsif slug.include? 'function'
            type = 'function'
        elsif slug.include? 'class'
            type = 'class'
        else
            type = 'others'
        end
        type
      end

      def additional_entries
        names = at_css('#firstHeading').content.split(',')[1..-1]
        names.concat ADDITIONAL_NAMES[name] || []
        names.map { |mapname| [get_custom_name(mapname),nil,get_type,get_parsed_uri_by_name(mapname),get_parsed_uri, get_docset] }
      end

      def include_default_entry?
         true
      end
    end
  end
end

module Docs
  class Cpp
    class EntriesFilter < Docs::EntriesFilter
      EXCLUDED_PATH = ['C++', 'Standard Library header files', 'std::vector<bool>']

      REPLACE_NAMES = {
        'Concepts' => 'C++ concepts',
        'Utility library' => 'Utilities library',
        'C Date and time utilities' => 'C-style date and time utilities',
        'Localization library' => 'Localizations library',
        'Experimental C++ standard libraries' => 'Experimental libraries',
        'Source file inclusion' => '#include directive' }

      REPLACE_PARENTS = {
        '/cpp/dynamic_memory_management' => '/cpp/utilities_library/dynamic_memory_management'}

      def get_name
        if at_css('.t-navbar-head >.selflink')
            name = at_css('.t-navbar-head >.selflink').content.strip
        else
            name = at_css('#firstHeading').content.strip
        end
        name.remove! 'std::experimental::filesystem::'
        name.remove! %r{\s\(.+\)}
        name.sub! %r{\AStandard library header <(.+)>\z}, '\1'
        name = REPLACE_NAMES[name] || name
        if slug.end_with? '2'
            name += '2'
        end
        name
      end

      def get_custom_name(customname)
        customname.remove! %r{\s\(.+\)}
        customname.sub! %r{\AStandard library header <(.+)>\z}, '\1'
        customname = REPLACE_NAMES[customname] || customname
        if slug.end_with? '2'
            customname += '2'
        end
        customname
      end

      def get_parsed_uri_by_name(customname)
        customname.remove! %r{\s\(.+\)}
        customname.sub! %r{\AStandard library header <(.+)>\z}, '\1'
        customname = REPLACE_NAMES[customname] || customname
        if slug.end_with? '2'
            customname += '2'
        end
        customparsed_uri = get_parsed_uri + '/' + self.urilized(customname)
      end
      
      def get_docset
        docset = context[:root_title]
        docset
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
         return [] unless include_default_entry?
         names = at_css('#firstHeading').content.remove(%r{\(.+?\)}).split(',')[1..-1]
         names.each(&:strip!).reject! do |name|
           name.size <= 2 || name == '...' || name =~ /\A[<>]/ || name.start_with?('operator')
         end
         names.map { |mapname| [get_custom_name(mapname),nil,get_type,get_parsed_uri_by_name(mapname),get_parsed_uri, get_docset] }
       end

       def include_default_entry?
         @include_default_entry = true #at_css('.t-navbar > div:nth-child(4) > a') && at_css('#firstHeading').content !~ /\A\s*operator./
         return @include_default_entry
       end
    end
  end
end
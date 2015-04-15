module Docs
  class Cpp
    class EntriesFilter < Docs::EntriesFilter
      EXCLUDED_PATH = ['C++']
      IGNORE_ADDITIONAL_ENTRY = %w(
        locale/moneypunct/neg_format
        locale/moneypunct/positive_sign
        locale/numpunct/truefalsename
        numeric/fenv/FE_exceptions
        atomic/atomic_compare_exchange
        numeric/math/fp_categories
        numeric/math/fp_categories
        numerics_library/common_mathematical_functions
        )

      REPLACE_NAMES = {
        'Error directive' => '#error directive',
        'Filename and line information' => '#line directive',
        'Implementation defined behavior control' => '#pragma directive',
        'Replacing text macros' => '#define directive',
        'Source file inclusion' => '#include directive' }

      def get_name
        return slug.split('/').last.tr('_', ' ') if IGNORE_ADDITIONAL_ENTRY.include? slug
        name = at_css('#firstHeading').content.strip
        name.remove! 'C++ concepts: '
        name.remove! 'C++ keywords: '
        name.remove! 'C++ '
        name.remove! %r{\s\(.+\)}
        name.sub! %r{\AStandard library header <(.+)>\z}, '\1'
        customname = name.split(',').first
        name = REPLACE_NAMES[name] || name
        name
      end

      def get_parsed_uri_by_name(customname)
        puts 'subname: ' + customname
        customname.remove! 'C++ concepts: '
        customname.remove! 'C++ keywords: '
        customname.remove! 'C++ '
        customname.remove! %r{\s\(.+\)}
        customname.sub! %r{\AStandard library header <(.+)>\z}, '\1'
        customname = name.split(',').first
        customname = REPLACE_NAMES[customname] || customname
        if parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(customname)
        else
            parsed_uri = get_parsed_uri + '/' + self.urilized(customname)
        end
        parsed_uri
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
        xpath('//div[@class="t-navbar-head"]/a').each do |node|
           link = node.content.strip
           if not EXCLUDED_PATH.include? link
               parent_uri += '/' + self.urilized(link)
           end
        end
        parent_uri
      end

      def get_type
        if at_css('#firstHeading').content.include?('C++ keyword')
          'Keywords'
        elsif subpath.start_with?('experimental')
          'Experimental libraries'
        elsif type = at_css('.t-navbar > div:nth-child(4) > :first-child').try(:content)
          type.strip!
          type.remove! ' library'
          type.remove! ' utilities'
          type.remove! 'C++ '
          type.capitalize!
          type
        end
      end

      def additional_entries
         puts 'slug: #' + slug + '#'
         return [] if IGNORE_ADDITIONAL_ENTRY.include? slug
         return [] unless include_default_entry?
         names = at_css('#firstHeading').content.remove(%r{\(.+?\)}).split(',')[1..-1]
         names.each(&:strip!).reject! do |name|
           name.size <= 2 || name == '...' || name =~ /\A[<>]/ || name.start_with?('operator')
         end
         names.map { |mapname| [mapname,'additional',get_type,get_parsed_uri_by_name(mapname),get_parent_uri, get_docset] }
       end

       def include_default_entry?
         @include_default_entry = at_css('.t-navbar > div:nth-child(4) > a') && at_css('#firstHeading').content !~ /\A\s*operator./
         return @include_default_entry if defined? @include_default_entry
       end
    end
  end
end
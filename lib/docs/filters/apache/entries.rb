module Docs
  class Apache
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        if slug == 'mod/'
          'Modules'
        elsif slug == 'programs/'
          'Programs'
        elsif slug == 'mod/core'
          'core'
        else
          name = at_css('h1').content.strip
          name.remove! %r{\ Support\z}i
          name.remove! %r{in\ Apache\z}
          name.remove! %r{\ documentation\z}i
          name.remove! %r{\AApache\ (httpd\ )?(Tutorial:\ )?}i
          name.remove! 'HTTP Server Tutorial: '
          name.sub! 'Module mod_', 'mod_'
          name.remove! %r{\ \-.*} if slug.start_with?('programs')
          name
        end
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        parsed_uri = get_custom_parent_uri + '/' + self.urilized(name)
        parsed_uri
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name)
        end
        puts 'parsed_uri: ' + parsed_uri
        parsed_uri
      end

      def get_parent_uri
        get_custom_parent_uri
          # parent_uri = 'null'
      end

      def get_custom_parent_uri
        # puts 'slug: ' + slug
        if slug.start_with?('howto')
          parent_uri = 'null'
        elsif slug.start_with?('platform/') and !slug.end_with? 'platform/' and !slug.end_with? 'index'
          parent_uri = '/apache/platform_specific_notes'
        elsif slug.start_with?('programs/') and !slug.end_with? 'programs/' and !slug.end_with? 'index'
          parent_uri = '/apache/programs'
        elsif slug.start_with?('misc/') and !slug.end_with? 'misc/' and !slug.end_with? 'index'
          parent_uri = '/apache/miscellaneous'
        elsif slug.start_with?('mod/') and !slug.end_with? 'mod/' and !slug.end_with? 'index'
          parent_uri = '/apache/modules'
        elsif slug.start_with?('ssl/') and !slug.end_with? 'ssl/' and !slug.end_with? 'index'
          parent_uri = '/apache/ssltls_encryption'
        elsif slug.start_with?('rewrite/') and !slug.end_with? 'rewrite/' and !slug.end_with? 'index'
          parent_uri = '/apache/mod_rewrite'
        elsif slug.start_with?('vhosts/') and !slug.end_with? 'vhosts/' and !slug.end_with? 'index'
          parent_uri = '/apache/virtual_host'
        else
          parent_uri = 'null'
        end
        # puts parent_uri
        parent_uri
      end
      def get_type
        if slug.start_with?('howto')
          'guide'
        elsif slug.start_with?('platform')
          'platforms'
        elsif slug.start_with?('programs')
          'programs'
        elsif slug.start_with?('misc')
          'others'
        elsif slug.start_with?('mod/')
          'modules'
        elsif slug.start_with?('ssl/')
          'guide'
        elsif slug.start_with?('rewrite/')
          'guide'
        elsif slug.start_with?('vhosts/')
          'guide'
        else
          'others'
        end
      end

      def additional_entries
        css('.directive-section > h2').each_with_object [] do |node, entries|
          name = node.content.strip
          next unless name.sub!(/\ Directive\z/, '')
          name.prepend "#{self.name.start_with?('MPM') ? 'MPM' : self.name}: "
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type, custom_parsed_uri, get_custom_parent_uri, get_docset]
        end
      end
    end
  end
end

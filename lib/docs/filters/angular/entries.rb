module Docs
  class Angular
    class EntriesFilter < Docs::EntriesFilter
      REPLACE_TYPES = {
        'ng directives' => 'directive',
        'ng services' => 'object',
        'ng providers' => 'object',
        'ng functions' => 'function',
        'ngMock' => 'test',
        'ng objects' => 'object',
        'ngAria' => 'object',
        'auto' => 'module',
        'ng types' => 'type',
        'ngCookies' => 'object',
        'ng filters' => 'function',
        'ng' => 'core',
        'ngMessages' => 'view',
        'ngRoute' => 'configuration',
        'ngTouch' => 'view',
        'ngSanitize' => 'function',
        'ng inputs' => 'view',
        'ngAnimate' => 'view',
        'ngMockE2E' => 'test',
        'ngResource' => 'network',
      }
      def get_name
        if slug!= 'index'
          name = css('h1').first.content.strip
        else
          name = 'API Reference'
        end
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
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
        parent_uri = context[:docset_uri]
        xpath('//nav[@class="crumbs"]//a/text()').each do |node|
           link = node.content.strip
           if not EXCLUDED_PATH.include? link
              parent_uri += '/' + self.urilized(link)
           end
        end
        if parent_uri == context[:docset_uri]
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        type = slug.split('/').first
        type << " #{subtype}s" if type == 'ng' && subtype
        REPLACE_TYPES[type] || 'others'
      end

      def subtype
        return @subtype if defined? @subtype
        node = at_css '.api-profile-header-structure'
        data = node.content.match %r{(\w+?) in module} if node
        @subtype = data && data[1]
      end

      def additional_entries
        entries = []

        css('ul.methods').each do |list|
          list.css('> li[id]').each do |node|
            next unless heading = node.at_css('h3')
            name = heading.content.strip
            name.sub! %r{\(.*\);}, '()'
            name.prepend "#{self.name.split.first}."
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
          end
        end

        entries
      end

      def include_default_entry?
        if get_name.include? 'Index of '
          return false
        else
          return true
        end
      end
    end
  end
end

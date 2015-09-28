module Docs
  class Laravel
    class EntriesFilter < Docs::ReflyEntriesFilter
      REPLACE_TYPE = {
        'Pagination' => 'class',
        'Cookie\Middleware' => 'network',
        'Routing\Controllers' => 'network',
        'Session' => 'network',
        'Routing' => 'network',
        'Console' => 'console',
        'Events' => 'event',
        'Auth' => 'security',
        'Filesystem' => 'io',
        'Bus' => 'network',
        'Container' => 'class',
        'Queue' => 'class',
        'Support' => 'class',
        'Validation' => 'class',
        'Workbench' => 'utils',
        'Exception' => 'object',
        'Html' => 'object',
        'Redis' => 'object',
        'Cache' => 'object',
        'Cookie' => 'object',
        'Foundation\Bus' => 'others',
        'Mail' => 'network',
        'Log' => 'object',
        'Encryption' => 'class',
        'Config' => 'configuration',
        'View' => 'class',
        'Translation' => 'class',
        'Auth.Middleware' => 'security',
        'Foundation.Auth' => 'security',
        'Contracts.Auth' => 'security',
        'Auth.Passwords' => 'security',
        'Auth.Console' => 'security',
        'Auth.Reminders' => 'security',
        'Foundation' => 'class',
        'Pipeline' => 'object',
        'Http' => 'network',
        'IlluminateQueueClosure' => 'class',
        'Illuminate' => 'class',
        'index' => 'others',
        'Hashing' => 'class',
      }
      EXCLUDED_PATH = []
      def get_name
        if api_page?
          breadcrumbs = xpath('//ol[@class="breadcrumb"]/li')
          if breadcrumbs.size>0
            name = breadcrumbs.pop.content.strip
          else
            name = at_css('h1').content.strip
          end
          name
        else
          at_css('h1').content.strip
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
        parent_uri = context[:docset_uri]
        breadcrumbs = xpath('//ol[@class="breadcrumb"]//a/text()')
        breadcrumbswithreference = xpath('//ol[@class="breadcrumb"]/li')
        breadcrumbswithreference.shift
        if breadcrumbs.size==breadcrumbswithreference.size and breadcrumbs.size>0
          breadcrumbs.pop
        end
        breadcrumbs.each do |node|
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
        return 'guide' unless api_page?
        type = slug.remove('api/5.0/').remove('Illuminate/').remove(/\/\w+?\z/).gsub('/', '.')
        if type.start_with? 'Database'
          type = 'database'
        elsif type.include? 'Auth'
          type = 'security'
        elsif type.start_with?('Contracts')
          type = 'class'
        elsif type.include? '.'
          type = 'class'
        end
        REPLACE_TYPE[type] || type
      end


      def additional_entries
        return [] if root_page? || !api_page?
        base_name = self.name.remove(/\(.+\)/).strip

        css('h3[id^="method_"]').each_with_object [] do |node, entries|
          next if node.at_css('.location').content.start_with?('in')

          name = node['id'].remove('method_')
          name.prepend "#{base_name}::"
          name << '()'
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type, custom_parsed_uri, get_parsed_uri, get_docset]
        end
      end

      def api_page?
        subpath.start_with?('/api')
      end

      def include_default_entry?
        subpath != '/api/5.0/classes.html'
      end
    end
  end
end
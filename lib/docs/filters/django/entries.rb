module Docs
  class Django
    class EntriesFilter < Docs::EntriesFilter
      REPLACE_TYPES = {
        'django.contrib.admin'        => 'core',
        'django.contrib.auth'         => 'others',
        'django.apps'                 => 'configuration',
        'django.conf'                 => 'configuration',
        'django.setup'                => 'configuration',
        'django.contrib.contenttypes' => 'type',
        'django.core'                 => 'core',
        'django.db.backends'          => 'core',
        'django.contrib.postgres'     => 'data',
        'django.db.connection'        => 'data',
        'django.db.migrations'        => 'data',
        'django.db.models'            => 'data',
        'django.db.transaction'       => 'data',
        'django.contrib.flatpages'    => 'data',
        'django.contrib.gis'          => 'data',
        'django.middleware'           => 'data',
        'django.dispatch'             => 'network',
        'django.contrib.redirects'    => 'network',
        'django.contrib.sessions'     => 'network',
        'django.shortcuts'            => 'network',
        'django.http'                 => 'network',
        'django.utils'                => 'method',
        'django.contrib.messages'     => 'method',
        'django.contrib.sitemaps'     => 'configuration',
        'django.contrib.sites'        => 'configuration',
        'django.contrib.staticfiles'  => 'configuration',
        'django.contrib.syndication'  => 'configuration',
        'django.template'             => 'view',
        'django.views'                => 'view',
        'django.forms'                => 'view',
        'django.test'                 => 'others',
      }
      def get_name
        at_css('h1').content.remove("\u{00b6}")
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
          parent_uri = 'null'
      end

      def get_type
        case subpath
        when /\Atopics/
          'guide'
        when /\Aintro/
          'guide'
        when /\Ahowto/
          'guide'
        when /\Aref/
          'function'
        else
          'others'
        end
      end

      def additional_entries
        entries = []

        css('dl.function', 'dl.class', 'dl.method', 'dl.attribute').each do |node|
          next unless id = node.at_css('dt')['id']
          next unless name = id.dup.sub!('django.', '')

          path = name.split('.')
          type = "django.#{path.first}"
          type << ".#{path.second}" if %w(contrib db).include?(path.first)

          name.remove! 'contrib.'
          name << '()' if node['class'].include?('method') || node['class'].include?('function')
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, id, REPLACE_TYPES[type], custom_parsed_uri, get_parsed_uri, get_docset]
        end

        entries
      end

      def include_default_entry?
        true #at_css('#sidebar a[href="index"]')
      end
    end
  end
end

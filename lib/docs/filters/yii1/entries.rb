module Docs
  class Yii1
    class EntriesFilter < Docs::EntriesFilter
      REPLACE_TYPES = {
        'system.web.auth' => 'authentication',
        'system.web.actions' => 'web',
        'system.web' => 'web',
        'zii.widgets' => 'web',
        'system.web.widgets.pagers' => 'web',
        'system.web.widgets.captcha' => 'web',
        'system.web.filters' => 'web',
        'zii.widgets.jui' => 'web',
        'system.web.renderers' => 'web',
        'system.web.form' => 'web',
        'system.web.widgets' => 'web',
        'zii.widgets.grid' => 'web',
        'system.web.services' => 'web',
        'system.db.ar' => 'data',
        'system.db' => 'data',
        'system.db.schema.oci' => 'data',
        'system.db.schema.cubrid' => 'data',
        'system.db.schema' => 'data',
        'system.db.schema.mssql' => 'data',
        'system.db.schema.mysql' => 'data',
        'system.db.schema.pgsql' => 'data',
        'system.db.schema.sqlite' => 'data',
        'zii.behaviors' => 'data',
        'system.web.helpers' => 'helper',
        'system.collections' => 'collection',
        'system.base' => 'system',
        'system.caching' => 'system',
        'system.caching.dependencies' => 'system',
        'system.validators' => 'system',
        'system.logging' => 'system',
        'system.i18n' => 'system',
        'system.i18n.gettext' => 'system',
        'system.console' => 'system',
        'system.gii' => 'system',
        'system.utils' => 'utils',
        'system.test' => 'testing'
      }
      def get_name
        at_css('h1').content.strip
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name)
        end
        parsed_uri
      end

      def get_parsed_uri_by_name(name)
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(name)
        end
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
        REPLACE_TYPES[css('.summaryTable td').first.content.strip] || css('.summaryTable td').first.content.strip
      end


      def additional_entries
        css('.detailHeader').inject [] do |entries, node|
          name = node.child.content.strip
          name.prepend self.name + (node.next_element.content.include?('public static') ? '::' : '->')
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

module Docs
  class Marionette
    class EntriesFilter < Docs::EntriesFilter
      REPLACED_TYPE = {
        'marionette.application' => 'core',
        'marionette.object' => 'object',
        'index' => 'others',
        'marionette.approuter' => 'configuration',
        'marionette.configuration' => 'configuration',
        'marionette.region' => 'configuration',
        'marionette.regionmanager' => 'configuration',
        'marionette.behavior' => 'function',
        'marionette.behaviors' => 'function',
        'marionette.functions' => 'function',
        'marionette.callbacks' => 'function',
        'marionette.view' => 'view',
        'marionette.itemview' => 'view',
        'marionette.collectionview' => 'view',
        'marionette.layoutview' => 'view',
        'marionette.compositeview' => 'view',
        'marionette.renderer' => 'view',
        'marionette.templatecache' => 'view',
        'marionette.controller' => 'module',
        'marionette.module' => 'module',
        '' => '',

      }
      def get_name
        name = at_css('h1').content.strip
        name.remove!(/Marionette./)
        name = name[0].upcase + name.from(1)
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        else
            parsed_uri = get_parsed_uri + '/' + self.urilized(name)
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
        'null'
      end

      def get_type
        REPLACED_TYPE[slug] || slug
      end

      def additional_entries
        entries = []
        css('h2').each do |node|
          name = node.content.strip
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type, custom_parsed_uri, get_parsed_uri, get_docset]
        end

        entries
      end
    end
  end
end

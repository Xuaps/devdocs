module Docs
  class ReactRouter
    class EntriesFilter < Docs::ReflyEntriesFilter
      REPLACE_TYPES = {
        'Index' => 'others',
        'API' => 'api',
        'Upgrade guide' => 'guide',
        'Introduction' => 'guide',
        'Glossary' => 'glossary',
        'Route configuration' => 'routing',
        'Dynamic routing' => 'routing',
        'Route Matching' => 'routing',
        'Navigating outside of components' => 'navigation',
        'Confirming navigation' => 'navigation',
        'Component lifecycle' => 'guide',
        'Server rendering' => 'guide',
        'Index routes' => 'routing',
        'Troubleshooting' => 'others'
      }
      REPLACE_NAMES = {
        'README.md' => 'Index',
        'API.md' => 'API',
        'Introduction.md' => 'Introduction',
        'UPGRADE_GUIDE.md' => 'Upgrade guide',
        'Glossary.md' => 'Glossary',
        'RouteConfiguration.md' => 'Route configuration',
        'DynamicRouting.md' => 'Dynamic routing',
        'RouteMatching.md' => 'Route Matching',
        'NavigatingOutsideOfComponents.md' => 'Navigating outside of components',
        'ConfirmingNavigation.md' => 'Confirming navigation',
        'ComponentLifecycle.md' => 'Component lifecycle',
        'ServerRendering.md' => 'Server rendering',
        'IndexRoutes.md' => 'Index routes',
        'Troubleshooting.md' => 'Troubleshooting'
      }
      def get_name
        REPLACE_NAMES[slug.split('/').last] || 'Otro Index'
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
        parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        parsed_uri
      end

      def get_parent_uri
       'null'
      end

      def get_type
        REPLACE_TYPES[get_name] || 'others'
      end

      def additional_entries
        entries = []
        css('h1 a', 'h2 a', 'h3 a', 'h4 a').each do |node|
            name = node.parent.content.strip
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['href'].remove('#'), get_type || 'others', custom_parsed_uri, get_parent_uri, get_docset]
        end
        entries
      end
    end
  end
end

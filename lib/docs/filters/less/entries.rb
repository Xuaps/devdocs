module Docs
  class Less
    class EntriesFilter < Docs::EntriesFilter
      def name
        at_css('h2').content
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + path
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

      def type
        root_page? ? 'Language' : 'others'
      end

      def additional_entries
        root_page? ? language_entries : function_entries
      end

      def language_entries
        entries = []

        css('h2').each do |node|
          name = node.content.strip
          name = 'Rulesets' if name == 'Passing Rulesets to Mixins'
          entries << [name, node['id'], type, get_parsed_uri, get_parent_uri, get_docset] unless name == 'Overview'
        end

        css('h3[id^="import-options-"]').each do |node|
          entries << ["@import #{node.content}", node['id'], type, get_parsed_uri, get_parent_uri, get_docset]
        end

        entries.concat [
          ['@var',              'variables-feature', type, get_parsed_uri, get_parent_uri, get_docset],
          ['@{} interpolation', 'variables-feature-variable-interpolation', type, get_parsed_uri, get_parent_uri, get_docset],
          ['url()',             'variables-feature-urls', type, get_parsed_uri, get_parent_uri, get_docset],
          ['@property',         'variables-feature-properties', type, get_parsed_uri, get_parent_uri, get_docset],
          ['@@var',             'variables-feature-variable-names', type, get_parsed_uri, get_parent_uri, get_docset],
          [':extend()',         'extend-feature', type, get_parsed_uri, get_parent_uri, get_docset],
          [':extend(all)',      'extend-feature-extend-all-', type, get_parsed_uri, get_parent_uri, get_docset],
          ['@arguments',        'mixins-parametric-feature-the-arguments-variable', type, get_parsed_uri, get_parent_uri, get_docset],
          ['@rest',             'mixins-parametric-feature-advanced-arguments-and-the-rest-variable', type, get_parsed_uri, get_parent_uri, get_docset],
          ['@import',           'import-directives-feature', type, get_parsed_uri, get_parent_uri, get_docset],
          ['when',              'mixin-guards-feature', type, get_parsed_uri, get_parent_uri, get_docset],
          ['.loop()',           'loops-feature', type, get_parsed_uri, get_parent_uri, get_docset],
          ['+:',                'merge-feature', type, get_parsed_uri, get_parent_uri, get_docset] ]

        entries
      end

      def function_entries
        entries = []
        type = nil

        css('*').each do |node|
          if node.name == 'h2'
            type = node.content
            type.sub! %r{(.+) Functions}, 'Functions: \1'
          elsif node.name == 'h4'
            entries << [node.content, node['id'], type]
          end
        end

        entries
      end
    end
  end
end

module Docs
  class Less
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        at_css('h2').content
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
          context[:docset_uri] + '/' + self.urilized(name.strip)
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
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
        if slug.include? 'functions'
            'function'
        elsif slug.include? 'features'
            'language'
        else
            'others'
        end
      end

      def additional_entries
        root_page? ? language_entries : function_entries
      end

      def language_entries
        entries = []

        css('h2').each do |node|
          name = node.content.strip
          name = 'Rulesets' if name == 'Passing Rulesets to Mixins'
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset] unless name == 'Overview'
        end

        css('h3[id^="import-options-"]').each do |node|
          name = "@import #{node.content}"
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end

        entries.concat [
          ['Pattern Matching',  'mixins-parametric-feature-pattern-matching', get_type, get_parsed_uri_by_name('Pattern Matching'), get_parent_uri, get_docset],
          ['@{} interpolation', 'variables-feature-variable-interpolation', get_type, get_parsed_uri_by_name('@{} interpolation'), get_parent_uri, get_docset],
          ['url()',             'variables-feature-urls', get_type, get_parsed_uri_by_name('url()'), get_parent_uri, get_docset],
          ['@property',         'variables-feature-properties', get_type, get_parsed_uri_by_name('@property'), get_parent_uri, get_docset],
          ['@@var',             'variables-feature-variable-names', get_type, get_parsed_uri_by_name('@@var'), get_parent_uri, get_docset],
          [':extend(all)',      'extend-feature-extend-all-', get_type, get_parsed_uri_by_name('extend(all)'), get_parent_uri, get_docset],
          ['@arguments',        'mixins-parametric-feature-the-arguments-variable', get_type, get_parsed_uri_by_name('@arguments'), get_parent_uri, get_docset],
          ['@rest',             'mixins-parametric-feature-advanced-arguments-and-the-rest-variable', get_type, get_parsed_uri_by_name('@rest'), get_parent_uri, get_docset]]

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
            name = node.content
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [node.content, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
          end
        end

        entries
      end
    end
  end
end

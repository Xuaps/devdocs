module Docs
  class Postgresql
    class EntriesFilter < Docs::ReflyEntriesFilter

      ADDITIONAL_ENTRIES = {
        'functions-geometry' => [
          %w(Geometry nil others /postgresql/geometry null PostgreSQL) ],
        'functions-math' => [
          %w(Math nil others /postgresql/math null PostgreSQL) ],
        'functions-json' => [
          %w(JSON-functions nil others /postgresql/data null PostgreSQL) ],
        'functions-range' => [
          %w(Range-functions nil others /postgresql/operator null PostgreSQL) ],
        'functions-net' => [
          %w(Network-functions nil others /postgresql/network null PostgreSQL) ],
        'functions' => [
          %w(Functions nil others /postgresql/function null PostgreSQL)],
        'runtime-config' => [
          %w(Configurations nil others /postgresql/configuration null PostgreSQL)],
        'functions-string' => [
          %w(Strings nil others /postgresql/string null PostgreSQL)],
        'datatype-character' => [
          %w(Types nil others /postgresql/type null PostgreSQL)],
        'functions-binarystring' => [
          %w(Binary-functions nil others /postgresql/binary_operators null PostgreSQL)]}

      SLUG_TYPES = {
        'configuration' =>               %w(runtime-config-replication runtime-config-resource runtime-config-logging)}
      REPLACE_NAMES = {
        'Sorting Rows'                    => 'ORDER BY',
        'Select Lists'                    => 'SELECT Lists',
        'Data Type Formatting Functions'  => 'Formatting Functions',
        'Enum Support Functions'          => 'Enum Functions',
        'Row and Array Comparisons'       => 'Array Comparisons',
        'Sequence Manipulation Functions' => 'Sequence Functions',
        'System Administration Functions' => 'Administration Functions',
        'System Information Functions'    => 'Information Functions' }
      SKIP_ENTRIES_ANCHOR = [
         '34char34',
         '124470',
         '12447'
      ]

      PREPEND_TYPES = [
        'Type Conversion',
        'Full Text Search',
        'Performance Tips',
        'Server Configuration',
        'Monitoring' ]

      REPLACE_TYPES = {
        'Routine Database Maintenance Tasks' => 'Maintenance',
        'High Availability, Load Balancing, and Replication' => 'High Availability',
        'Monitoring Database Activity' => 'Monitoring',
        'Monitoring Disk Usage' => 'Monitoring',
        'Reliability and the Write-Ahead Log' => 'Write-Ahead Log' }

      def base_name
        if at_css('h1')
            @base_name = clean_heading_name(at_css('h1').content)
        else
            @base_name = 'Reference'
        end
      end


      def get_name
        if %w(Overview Introduction).include?(base_name)
          result[:pg_chapter_name]
        elsif PREPEND_TYPES.include?(get_filtering_type)
          "#{get_filtering_type}: #{base_name}"
        else
          REPLACE_NAMES[base_name] || base_name
        end
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
          if get_type == 'others'
              parent_uri = 'null'
          else
              parent_uri = context[:docset_uri]+ '/' + self.urilized(get_type)
          end
      end

      def get_filtering_type
        return if initial_page?

        if result[:pg_up_path] == 'sql-commands.html'
          'Commands'
        elsif result[:pg_up_path].start_with?('reference-')
          'Applications'
        elsif type = result[:pg_chapter_name]
          if type.start_with?('Func') && (match = base_name.match(/\A(?!Form|Seq|Set|Enum)(.+) Func/))
            "Functions: #{match[1]}"
          else
            type.remove! 'SQL '
            REPLACE_TYPES[type] || type
          end
        end
      end

      def get_type
          if SLUG_TYPES['configuration'].include? slug
            'configuration'
          elsif slug.downcase.include? 'math'
            'math'
          elsif slug.downcase.include? 'geometry'
            'geometry'
          elsif slug.downcase.include? 'datatype' or slug.downcase.include? 'array'
            'type'
          elsif slug.downcase.include? 'bitstring' or slug.downcase.include? 'functions-string'
            'string'
          elsif slug.downcase.include? 'range' or slug.downcase.include? 'binarystring'
            'operator'
          elsif slug.downcase.include? 'json'
            'data'
          elsif slug.downcase.include? 'net'
            'network'
          elsif slug.downcase.include? 'function' or slug.downcase.include? 'fulltext'
             'function'
          else
             'others'
          end
      end

      def additional_entries
        return [] if skip_additional_entries?
        return config_additional_entries if get_filtering_type && get_filtering_type.include?('Configuration')
        return data_types_additional_entries.concat ADDITIONAL_ENTRIES['datatype-character'] if get_filtering_type == 'Data Types'
        return get_heading_entries('h3[id]') if slug == 'functions-xml'

        entries = get_heading_entries('h2[id]')
        case slug
        when 'queries-union'
          entries.concat get_custom_entries('p > .LITERAL:first-child')
        when 'queries-table-expressions'
          entries.concat get_heading_entries('h3[id]')
          entries.concat get_custom_entries('dt > .LITERAL:first-child')
        when 'functions-logical'
          entries.concat get_custom_entries('> table td:first-child > code')
        when 'functions-formatting'
          entries.concat get_custom_entries('#FUNCTIONS-FORMATTING-TABLE td:first-child > code')
        when 'functions-admin'
          entries.concat get_custom_entries('.TABLE td:first-child > code')
        when 'functions-string'
          entries.concat get_custom_entries('> div[id^="FUNC"] td:first-child > code').concat ADDITIONAL_ENTRIES[slug]
        when 'functions-math'
          entries.concat ADDITIONAL_ENTRIES[slug]
        when 'functions-geometry'
          entries.concat ADDITIONAL_ENTRIES[slug]
        when 'runtime-config'
          entries.concat ADDITIONAL_ENTRIES[slug]
        when 'functions-json'
          entries.concat ADDITIONAL_ENTRIES[slug]
        when 'functions-range'
          entries.concat ADDITIONAL_ENTRIES[slug]
        when 'functions-net'
          entries.concat ADDITIONAL_ENTRIES[slug]
        when 'functions-binarystring'
          entries.concat ADDITIONAL_ENTRIES[slug]
        when 'functions'
          entries.concat ADDITIONAL_ENTRIES[slug]
        else
          if get_filtering_type && get_filtering_type.start_with?('Functions')
            entries.concat get_custom_entries('> .TABLE td:first-child > code:first-child')
            entries.concat %w(IS NULL BETWEEN DISTINCT\ FROM).map { |name| ["#{self.name}: #{name}", nil, get_type, get_parsed_uri_by_name(name), get_parent_uri, get_docset] } if slug == 'functions-comparison'
          end
        end

        entries
      end

      def config_additional_entries
        css('.VARIABLELIST dt[id]').map do |node|
          name = node.at_css('.VARNAME').content
          custom_parsed_uri = get_parsed_uri_by_name(name)
          ["Config: #{name}", node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end

      def data_types_additional_entries
        selector = case slug
        when 'rangetypes'
          'li > p > .TYPE:first-child'
        when 'datatype-textsearch'
          '.SECT2 > .TYPE'
        else
          '.CALSTABLE td:first-child > .TYPE'
        end
        get_custom_entries(selector)
      end

      def include_default_entry?
        true #!initial_page? && !at_css('.TOC')
      end

      SKIP_ENTRIES_SLUGS = [
        'config-setting',
        'applevel-consistency' ]

      SKIP_ENTRIES_TYPES = [
        'Localization',
        'Type Conversion',
        'Full Text Search',
        'Performance Tips',
        'Client Authentication',
        'Managing Databases',
        'Maintenance',
        'Backup and Restore',
        'High Availability',
        'Monitoring' ]

      def skip_additional_entries?
        SKIP_ENTRIES_SLUGS.include?(slug) || SKIP_ENTRIES_TYPES.include?(get_filtering_type)
      end

      def clean_heading_name(name)
        name.remove! %r{\A[\d\.\s]+}
        name.remove! 'Using '
        name.remove! %r{\AThe }
        name.remove! ' (Common Table Expressions)'
        name
      end

      def get_heading_entries(selector)
        css(selector).each_with_object([]) do |node, entries|
          name = node.content
          clean_heading_name(name)
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << ["#{name}", node['id'], get_type, custom_parsed_uri, parent_uri, docset] unless SKIP_ENTRIES_ANCHOR.include?(node['id'])
        end
      end


      def get_custom_entries(selector)
        css(selector).each_with_object([]) do |node, entries|
          name = node.content
          name.remove! %r{\(.*?\)}m
          name.remove! %r{\[.*?\]}m
          name.squeeze! ' '
          name.remove! %r{\([^\)]*\z} # bug fix: json_populate_record
          name = '||' if name.include? ' || '
          case slug
            when 'functions-bitstring'
              name.prepend 'Bitstring operator '
            when 'functions-string'
              name.prepend 'String operator '
            end
          id = name.gsub(/[^a-z0-9\-_]/) { |char| char.ord }
          id = id.parameterize
          unless entries.any? { |entry| entry[0] == name }
            node['id'] = id
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, id, get_type, custom_parsed_uri, parent_uri, docset] unless SKIP_ENTRIES_ANCHOR.include?(id)
          end
        end
      end

      def skip_heading?(name)
        %w(Usage\ Patterns Portability Caveats Overview).include?(name) ||
        (get_filtering_type.start_with?('Functions') && slug != 'functions-xml' && name.split.first.upcase!)
      end
    end
  end
end

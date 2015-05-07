module Docs
  class Coffeescript
    class EntriesFilter < Docs::EntriesFilter
      CUSTOMENTRIES = [
        ['coffee command',                  'usage',                    'others'],
        ['Literate mode',                   'literate',                 'others'],
        ['Functions',                       'literals',                 'language'],
        ['operator ->',                              'literals',                 'operator'],
        ['Objects and arrays',              'objects_and_arrays',       'object'],
        ['Lexical scoping',                 'lexical-scope',            'language'],
        ['if...then...else',                'conditionals',             'statement'],
        ['unless',                          'conditionals',             'statement'],
        ['... splats',                      'splats',                   'language'],
        ['for...in',                        'loops',                    'statement'],
        ['for...in...by',                   'loops',                    'statement'],
        ['for...in...when',                 'loops',                    'statement'],
        ['for...of',                        'loops',                    'statement'],
        ['while',                           'loops',                    'statement'],
        ['until',                           'loops',                    'statement'],
        ['loop',                            'loops',                    'statement'],
        ['do',                              'loops',                    'statement'],
        ['Array slicing and splicing',      'slices',                   'language'],
        ['Ranges',                          'slices',                   'language'],
        ['Expressions',                     'expressions',              'language'],
        ['operator ?',                               'the-existential-operator', 'operator'],
        ['operator ?=',                              'the-existential-operator', 'operator'],
        ['operator ?.',                              'the-existential-operator', 'operator'],
        ['class',                           'classes',                  'class'],
        ['Inheritance',                     'classes',                  'class'],
        ['super',                           'classes',                  'class'],
        ['Destructuring assignment',        'destructuring',            'language'],
        ['Bound Functions',                 'fat-arrow',                'statement'],
        ['Embedded JavaScript',             'embedded',                 'language'],
        ['switch...when...else',            'switch',                   'statement'],
        ['try...catch...finally',           'try',                      'statement'],
        ['Chained comparisons',             'comparisons',              'language'],
        ['String Interpolation',            'strings',                  'language'],
        ['Block strings',                   'strings',                  'language'],
        ['Block comments',                  'strings',                  'language'],
        ['Block regexes',                   'regexes',                  'language'],
        ['cake command',                    'cake',                     'others'],
        ['Cakefile',                        'cake',                     'others'],
        ['Source maps',                     'source-maps',              'others']
      ]

      def get_name
        'Index'
      end

      def get_docset
        context[:root_title]
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
        context[:docset_uri] + '/' + self.urilized(get_name)
      end

      def get_parent_uri
        'null'
      end

      def get_type
         'others'
      end
      def additional_entries
        entries = []
        CUSTOMENTRIES.each do |entry|
            name = entry[0]
            id = entry[1]
            type = entry[2]
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, id, type, custom_parsed_uri, get_parent_uri, get_docset]
        end
        #entries = ENTRIES.dup

        # Operators
        css('.definitions td:first-child > code').each do |node|
          node.content.split(', ').each do |name|
            next if %w(true false yes no on off this).include?(name)
            name.sub! %r{\Aa (.+) b\z}, '\1'
            name = 'operator ' + name
            id = name_to_id(name)
            node['id'] = id
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, id, 'operator', custom_parsed_uri, get_parent_uri, get_docset]
          end
        end

        entries
      end

      def include_default_entry?
        true
      end

      def name_to_id(name)
        case name
          when '**' then 'pow'
          when '//' then 'floor'
          when '%%' then 'mod'
          else name.parameterize
        end
      end
    end
  end
end

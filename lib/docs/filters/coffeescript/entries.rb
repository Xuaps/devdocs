module Docs
  class Coffeescript
    class EntriesFilter < Docs::EntriesFilter
      CUSTOMENTRIES = [
        ['coffee command',              'usage',                    'others'],
        ['Literate mode',               'literate',                 'others'],
        ['Functions',                   'literals',                 'Language'],
        ['->',                          'literals',                 'Statements'],
        ['Objects and arrays',          'objects_and_arrays',       'Language'],
        ['Lexical scoping',             'lexical-scope',            'Language'],
        ['if...then...else',            'conditionals',             'Statements'],
        ['unless',                      'conditionals',             'Statements'],
        ['... splats',                  'splats',                   'Language'],
        ['for...in',                    'loops',                    'Statements'],
        ['for...in...by',               'loops',                    'Statements'],
        ['for...in...when',             'loops',                    'Statements'],
        ['for...of',                    'loops',                    'Statements'],
        ['while',                       'loops',                    'Statements'],
        ['until',                       'loops',                    'Statements'],
        ['loop',                        'loops',                    'Statements'],
        ['do',                          'loops',                    'Statements'],
        ['Array slicing and splicing',  'slices',                   'Language'],
        ['Ranges',                      'slices',                   'Language'],
        ['Expressions',                 'expressions',              'Language'],
        ['?',                           'the-existential-operator', 'Operators'],
        ['?=',                          'the-existential-operator', 'Operators'],
        ['?.',                          'the-existential-operator', 'Operators'],
        ['class',                       'classes',                  'Statements'],
        ['extends',                     'classes',                  'Operators'],
        ['super',                       'classes',                  'Statements'],
        ['::',                          'classes',                  'Operators'],
        ['Destructuring assignment',    'destructuring',            'Language'],
        ['=>',                          'fat-arrow',                'Statements'],
        ['Embedded JavaScript',         'embedded',                 'Language'],
        ['switch...when...else',        'switch',                   'Statements'],
        ['try...catch...finally',       'try',                      'Statements'],
        ['Chained comparisons',         'comparisons',              'Language'],
        ['#{} interpolation',           'strings',                  'Language'],
        ['Block strings',               'strings',                  'Language'],
        ['"""',                         'strings',                  'Language'],
        ['Block comments',              'strings',                  'Language'],
        ['###',                         'strings',                  'Language'],
        ['Block regexes',               'regexes',                  'Language'],
        ['cake command',                'cake',                     'others',],
        ['Cakefile',                    'cake',                     'others',],
        ['Source maps',                 'source-maps',              'others']
      ]

      def get_docset
        context[:root_title]
      end

      def get_parsed_uri
        context[:docset_uri] + '/' + path
      end

      def get_parent_uri
        subpath = *path.split('/')
        if subpath.length > 1
            (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            'null'
        end
      end

      def get_type
         'others'
      end
      def additional_entries
        CUSTOMENTRIES.each do |entry|
            id = entry[1]
            custom_parsed_uri = get_parent_uri + '#' + id
            entries << [entry, custom_parsed_uri, get_parent_uri, get_docset]
        end
        entries = ENTRIES.dup

        # Operators
        css('.definitions td:first-child > code').each do |node|
          node.content.split(', ').each do |name|
            next if %w(true false yes no on off this).include?(name)
            name.sub! %r{\Aa (.+) b\z}, '\1'
            id = name_to_id(name)
            node['id'] = id
            custom_parsed_uri = get_parsed_uri + '#' + id
            entries << [name, id, 'operators', custom_parsed_uri, get_parent_uri, get_docset]
          end
        end

        entries
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

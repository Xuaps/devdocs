module Docs
  class Swiftreference
    class EntriesFilter < Docs::ReflyEntriesFilter
      NOT_VALID_REFERENCES = [
        'Subscripts',
        'Type Aliases',
        'Type Methods',
        'Type Properties',
        'Operator Functions',
        'Instance Properties',
        'Instance Methods',
        'Initializers',
        'Enumeration Cases',
        'Associated Types'
      ]
      TYPES_TYPE_NAMES = [
        'Float',
        'String',
        'Bit',
        'Bool',
        'Character',
        'UTF16',
        'UTF8',
        'UTF32',
        'Double',
        'BooleanLiteralConvertible',
        'Comparable',
        'String.UTF16View',
        'String.UTF8View',
        'AutoreleasingUnsafeMutablePointer',
        'CustomDebugStringConvertible',
        'Equatable'
      ]
      TYPES_TYPE_OBJECT = [
        'CustomDebugStringConvertible',
        'COpaquePointer',
        'CustomDebugStringConvertible',
        'Zip2Generator',
        'Zip2Sequence',
        'CustomStringConvertible',
        'CustomReflectable',
        'CustomStringConvertible',
        'CVaListPointer',
        'EmptyGenerator',
        'EnumerateGenerator',
        'ManagedBufferPointer',
        'CVaListPointer'
      ]
      def get_name
        if css('.chapter-name')
          name = css('.chapter-name').first.content.strip
        else
          name = slug.strip
        end
        name
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
        parsed_uri = get_parsed_uri + '/' + self.urilized(name)
        parsed_uri
      end

      def get_parent_uri
       'null'
      end

      def get_type
        if get_name.include? 'Type' or get_name.include? 'Int' or get_name.include? 'Index' or TYPES_TYPE_NAMES.include? get_name
          type = 'type'
        elsif get_name.include? 'Array' or get_name.include? 'Collection' or get_name.include? 'Dictionary'
          type = 'collection'
        elsif get_name.include? 'Operators'
          type = 'operator'
        elsif get_name.include? 'Functions' or get_name.include? 'AbsoluteValuable'
          type = 'function'
        elsif get_name.include? 'Methods'
          type = 'method'
        elsif get_name.include? 'Extensions'
          type = 'utils'
        elsif get_name.include? 'Expressions'
          type = 'expression'
        elsif get_name.include? 'Statements' or get_name.include? 'Lexical' or get_name.include? 'Patterns'
          type = 'statement'
        elsif get_name.include? 'Properties' or get_name.include? 'Attributes' or get_name.include? 'Parameters'
          type = 'property'
        elsif get_name.include? 'Basics' or get_name.include? 'Swift' or get_name.include? 'Generics' or get_name.include? 'Chaining' or get_name.include? 'Grammar'
          type = 'guide'
        elsif get_name.include? 'Closures' or get_name.include? 'Reference' or get_name.include? 'Control' or get_name.include? 'Declarations' or get_name.include? 'Protocols' or get_name.include? 'Handling'
          type = 'language'
        elsif get_name.include? 'Classes' or get_name.include? 'Subscripts' or get_name.include? 'Inheritance' or get_name.include? 'Initialization' or get_name.include? 'Deinitialization' or get_name.include? 'Any'
          type = 'class'
        elsif TYPES_TYPE_OBJECT.include? get_name
          type = 'object'
        else
          type = 'others'
        end
        type
      end

      def additional_entries
        entries = []
        css('h3.section-name').each do |node|
          id = node['id']
          name = node.content.strip
          if id != '' and not NOT_VALID_REFERENCES.include? name
            custom_parsed_uri = get_parsed_uri_by_name(name)
            custom_parent_uri = get_parsed_uri
            entries << [name, id, get_type || 'others', custom_parsed_uri, custom_parent_uri, get_docset]
          end
        end
        entries
      end
    end
  end
end

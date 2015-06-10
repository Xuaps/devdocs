module Docs
  class Lodash
    class EntriesFilter < Docs::EntriesFilter
      TYPENAMES = {
         'Methods'    => 'method',
         'Chain'      => 'method',
         'Math'       => 'function',
         'Function'   => 'function',
         'Utility'    => 'function',
         'Lang'       => 'function',
         'Collection' => 'collection',
         'Array'      => 'collection',
         'Properties' => 'property',
         'Object'     => 'object',
         'Number'     => 'type',
         'Date'       => 'type',
         'String'     => 'type'
      }
      def get_docset
        docset = context[:root_title]
        docset
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
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name)
        end
        parsed_uri
      end

      def get_parent_uri
        subpath = *path.split('/')
        if subpath.size > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type_by_name(type)
        TYPENAMES[type] || type
      end

      def get_type
        'others'
      end

      def include_default_entry?
        return false
      end

      def additional_entries
        entries = []

        css('h2').each do |node|
          type = node.content.split.first
          type.remove! %r{\W} # remove quotation marks

          node.parent.css('h3').each do |heading|
            name = heading.content
            name.sub! %r{\(.+?\)}, '()'
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, heading['id'], get_type_by_name(type), custom_parsed_uri, get_parent_uri, get_docset]

            if h4 = heading.parent.at_css('h4') and h4.content.strip == 'Aliases'
              h4.next_element.content.split(',').each do |n|
                custom_parsed_uri = get_parsed_uri_by_name(n)
                entries << ["#{n.strip}()", heading['id'], get_type_by_name(type), custom_parsed_uri, get_parent_uri, get_docset]
              end
            end
          end
        end

        entries
      end
    end
  end
end

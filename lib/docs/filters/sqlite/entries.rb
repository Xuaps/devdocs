module Docs
  class Sqlite
    class EntriesFilter < Docs::ReflyEntriesFilter
      TYPES_BY_SLUG = {
        'fts3' => 'command',
        'uri' => 'parameter',
        'compile' => 'configuration'
      }
      def get_name
        if css('h1').to_s!= ''
          name = css('h1').first.content.strip
        else
          name = css('h2').first.content.strip
        end
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
          get_parsed_uri + '/' + self.urilized(name)
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name.remove '%')
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name.remove '%')
        end
        parsed_uri
      end

      def get_parent_uri
        'null'
      end

      def get_type
        TYPES_BY_SLUG[slug] || 'guide'
      end


      def additional_entries
        entries = []
        if slug == 'compile'
          css('p b').each do |node|
            name = node.content
            if !name.include? ':'
              id = name
              node['id'] = id
              custom_parsed_uri = get_parsed_uri_by_name(name)
              entries << [name, id, get_type, custom_parsed_uri, get_parsed_uri, get_docset]
            end
          end
        end
        if slug == 'uri'
          css('dt b').each do |node|
            name = node.inner_html.split('<br>').first
            id = name
            node['id'] = id
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, id, get_type, custom_parsed_uri, get_parsed_uri, get_docset]
          end
        end
        if slug == 'fts3'
          css('h1[id]', 'h2[id]').each do |node|
            name = node.content.strip
            id = name
            node['id'] = id
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, id, get_type, custom_parsed_uri, get_parsed_uri, get_docset]
          end
        end
        entries
      end
    end
  end
end

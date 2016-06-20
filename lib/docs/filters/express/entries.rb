module Docs
  class Express
    class EntriesFilter < Docs::ReflyEntriesFilter
      def get_name
        name = css('h1').first.content
        # puts name
        name
      end
      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        parsed_uri = get_parsed_uri + '/' + self.urilized(name)
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
        'guide'
      end

      def get_type_by_name(name, id)
      	# name = 'uu'
      	# id = 'oo'
        if name.include? 'req.' or name.include? 'Request' or id.include? 'req.'
            'request'
        elsif name.include? 'app.' or name.include? 'Application' or id.include? 'app.'
             'application'
        elsif name.include? 'res.' or name.include? 'Response' or id.include? 'res.'
             'response'
        elsif name.include? 'router.' or name.include? 'Router' or id.include? 'router.'
             'router'
        else
            'others'
        end
      end

      def additional_entries
        entries = []
        css('h2', 'h3', 'h4').each do |node|
          if node.name == 'h2'
            name = node.content
            type = name
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type_by_name(name, node['id']), custom_parsed_uri, get_parsed_uri, get_docset] if type == 'Middleware'
            next
          elsif node.name == 'h4'
            name = node.content
            type = name
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type_by_name(name, node['id']), custom_parsed_uri, get_parsed_uri, get_docset]
            next
          elsif node.name == 'h3'
            next if type == 'Middleware'
            name = node.content.strip
            name.sub! %r{\(.+\)}, '()'
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type_by_name(name, node['id']), custom_parsed_uri, get_parsed_uri, get_docset]
          end
        end
        entries
      end
    end
  end
end

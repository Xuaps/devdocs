module Docs
  class Express
    class EntriesFilter < Docs::EntriesFilter
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

      def get_type(name, id)
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
        

        doc.children.each_with_object [] do |node, entries|
          if node.name == 'h2'
            name = node.content
            type = name
            node['id'] = name
            custom_parsed_uri = get_parsed_uri + '#' + node['id']
            entries << [name, node['id'], get_type(name, node['id']), custom_parsed_uri, get_parent_uri, get_docset] if type == 'Middleware'
            next
          elsif node.name == 'h3'
            next if type == 'Middleware'
            name = node.content.strip
            name.sub! %r{\(.+\)}, '()'
            custom_parsed_uri = get_parsed_uri + '#' + node['id']
            entries << [name, node['id'], get_type(name, node['id']), custom_parsed_uri, get_parent_uri, get_docset]
          end
        end
      end
    end
  end
end

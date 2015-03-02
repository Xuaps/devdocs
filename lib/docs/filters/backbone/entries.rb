module Docs
  class Backbone
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

      def additional_entries
        entries = []
        type = nil

        css('[id]').each do |node|
          # Module
          if node.name == 'h2'
            type = node.content.remove 'Backbone.'
            if type.capitalize! # sync, history
              custom_parsed_uri = get_parsed_uri + '#' + node['id']
              entries << [node.content, node['id'], type, custom_parsed_uri, get_parent_uri, get_docset]
            end
            next
          end

          # Built-in events
          if node['id'] == 'Events-catalog'
            node.next_element.css('li').each do |li|
              name = "#{li.at_css('b').content.delete('"').strip} event"
              id = name.parameterize
              li['id'] = id
              custom_parsed_uri = get_parsed_uri + '#' + id
              entries << [name, id, type, custom_parsed_uri, get_parent_uri, get_docset] unless name == entries.last[0]
            end
            next
          end

          # Method
          name = node.at_css('.header').content.split.first

          # Underscore methods
          if name == 'Underscore'
            node.next_element.css('li').each do |li|
              name = [type.downcase, li.at_css('a').content.split.first].join('.')
              id = name.parameterize
              li['id'] = id
              custom_parsed_uri = get_parsed_uri + '#' + id
              entries << [name, id, type, custom_parsed_uri, get_parent_uri, get_docset]
            end
            next
          end

          if %w(Events Sync).include?(type)
            name.prepend 'Backbone.'
          elsif type == 'History'
            name.prepend 'Backbone.history.'
          elsif name == 'extend'
            name.prepend "#{type}."
          elsif name.start_with? 'constructor'
            name = type
          elsif type != 'Utility'
            name.prepend "#{type.downcase}."
          end
          custom_parsed_uri = get_parsed_uri + '#' + node['id']
          entries << [name, node['id'], type, custom_parsed_uri, get_parent_uri, get_docset]
        end

        entries
      end
    end
  end
end

module Docs
  class Backbone
    class EntriesFilter < Docs::EntriesFilter


      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
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
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            parent_uri = 'null'
        end
      end

      def get_type(typename)
          if typename == 'events'
              'event'
          elsif typename == 'router' or  typename == 'utility' or  typename == 'sync' or  typename == 'model' or  typename == 'history'
              'function'
          elsif typename == 'collection'
              'collection'
          elsif typename == 'view'
              'view'
          else
              'others'
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
              name = node.content
              custom_parsed_uri = get_parsed_uri_by_name(name)
              entries << [name, node['id'], get_type(type.downcase), custom_parsed_uri, get_parent_uri, get_docset]
            end
            next
          end

          # Built-in events
          if node['id'] == 'Events-catalog'
            node.next_element.css('li').each do |li|
              name = "#{li.at_css('b').content.delete('"').strip} event"
              id = name.parameterize
              li['id'] = id
              custom_parsed_uri = get_parsed_uri_by_name(name)
              entries << [name, id, get_type(type.downcase), custom_parsed_uri, get_parent_uri, get_docset] unless name == entries.last[0]
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
              custom_parsed_uri = get_parsed_uri_by_name(name)
              entries << [name, id, get_type(type.downcase), custom_parsed_uri, get_parent_uri, get_docset]
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
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type(type.downcase), custom_parsed_uri, get_parent_uri, get_docset]
        end

        entries
      end
    end
  end
end

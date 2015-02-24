module Docs
  class Ember
    class EntriesFilter < Docs::EntriesFilter
      def include_default_entry?
        name != 'Handlebars Helpers'
      end

      def get_name
        name = at_css('.api-header').content.split.first
        # Remove "Ember." prefix if the next character is uppercase
        name.sub! %r{\AEmber\.([A-Z])(?!EATURES)}, '\1'
        name == 'Handlebars.helpers' ? 'Handlebars Helpers' : name
      end

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
            #TODO
            if parent_uri == '/ember/classes'
                parent_uri = 'null'
            end
        else
            parent_uri = 'null'
        end
      end

      def get_type
        if at_css('.api-header').content.include?('Module')
          'Modules'
        elsif name.start_with? 'DS'
          'Data'
        elsif name.start_with? 'RSVP'
          'RSVP'
        elsif name.start_with? 'Test'
          'Test'
        else
          name
        end
      end

      def additional_entries
        css('.item-entry').map do |node|
          heading = node.at_css('h2')
          name = heading.content.strip

          if self.name == 'Handlebars Helpers'
            name << ' (handlebars helper)'
            next [name, heading['id']]
          end

          # Give their own type to "Ember.platform", "Ember.run", etc.
          if self.type != 'Data' && name.include?('.')
            type = "#{self.name}.#{name.split('.').first}"
          end

          # "." = class method, "#" = instance method
          separator = '#'
          separator = '.' if self.name == 'Ember' || self.name.split('.').last =~ /\A[a-z]/ || node.at_css('.static')
          name.prepend self.name + separator

          name << '()'     if node['class'].include? 'method'
          name << ' event' if node['class'].include? 'event'

          [name.tr('#','.'), heading['id'], type, get_parsed_uri.tr('#','.'), get_parent_uri, get_docset]
        end
      end
    end
  end
end

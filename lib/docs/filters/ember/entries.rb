module Docs
  class Ember
    class EntriesFilter < Docs::EntriesFilter


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
        elsif name.include? 'helper' or name.include? 'inject' or name.include? 'Libraries'
          'Helpers'
        elsif name.include? 'Data' or name.include? 'Promise' or name.include? 'DS' or name.include? 'Binding' or name.include? 'Deferred' or name.include? 'RSVP' or name.include? 'Adapter' or name.include? 'ProxyMixin'
          'Data'
        elsif name.include? 'Controller'
          'Controller'
        elsif name.include? 'Array' or name.include? 'Set' or name.include? 'Enumerable' or name.include? 'SortableMixin'
          'Collection'
        elsif name.include? 'Application' or name.include? 'Observable' or name.include? 'Router' or name.include? 'Logger' or name.include? 'Instrumentation'
          'Application'
        elsif name.include? 'Test'
          'Test'
        elsif name.include? 'Handle' or name.include? 'Event' or name.include? 'TargetAction'
          'Events'
        elsif name.include? 'Location' or name.include? 'HTML' or name.include? 'Route'
          'Network'
        elsif name.include? 'Object' or  name.include? 'Comparable' or name.include? 'Copyable' or name.include? 'ComputedProperty' or name.include? 'Component' or name.include? 'String' or name.include? 'Freezable' or name.include? 'Error' or name.include? 'Date' or name.include? 'Namespace'
          'Object'
        elsif name.include? 'View' or name.include? 'TextArea' or name.include? 'TextField' or name.include? 'Checkbox' or name.include? 'Select' or name.include? 'InjectedProperty' or name.include? 'DefaultResolver'
          'View'
        elsif name.include? 'Ember'
          'Core'
        else
          'Others'
        end
      end

      def additional_entries
        css('.item-entry').map do |node|
          heading = node.at_css('h2')
          name = heading.content.strip

          if self.name == 'Handlebars Helpers'
            name << ' (handlebars helper)'
            custom_parsed_uri = get_parsed_uri + '#' + heading['id']
            next [name.tr('#', '.'), heading['id'], type, custom_parsed_uri, get_parent_uri, get_docset]
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
          custom_parsed_uri = get_parsed_uri + '#' + heading['id']
          [name.tr('#', '.'), heading['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

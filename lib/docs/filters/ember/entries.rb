module Docs
  class Ember
    class EntriesFilter < Docs::EntriesFilter
      ADDITIONAL_ENTRIES = {
        'modules/ember' => [
          %w(Modules nil others /ember/modules null EmberJS)],
        'data/classes/DS.Store' => [
          %w(Data/Classes nil class /ember/data/classes null EmberJS)],
        'data/modules/ember-data' => [
          %w(Data/Modules nil class /ember/data/modules null EmberJS)]}

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

      def get_type
        if at_css('.api-header').content.include?('Module')
          'modules'
        elsif name.include? 'helper' or name.include? 'inject' or name.include? 'Libraries'
          'helpers'
        elsif name.include? 'Data' or name.include? 'Promise' or name.include? 'DS' or name.include? 'Binding' or name.include? 'Deferred' or name.include? 'RSVP' or name.include? 'Adapter' or name.include? 'ProxyMixin'
          'data'
        elsif name.include? 'Controller'
          'controller'
        elsif name.include? 'Array' or name.include? 'Set' or name.include? 'Enumerable' or name.include? 'SortableMixin'
          'collection'
        elsif name.include? 'Application' or name.include? 'Observable' or name.include? 'Router' or name.include? 'Logger' or name.include? 'Instrumentation'
          'application'
        elsif name.include? 'Test'
          'test'
        elsif name.include? 'Handle' or name.include? 'Event' or name.include? 'TargetAction'
          'event'
        elsif name.include? 'Location' or name.include? 'HTML' or name.include? 'Route'
          'network'
        elsif name.include? 'Object' or  name.include? 'Comparable' or name.include? 'Copyable' or name.include? 'ComputedProperty' or name.include? 'Component' or name.include? 'String' or name.include? 'Freezable' or name.include? 'Error' or name.include? 'Date' or name.include? 'Namespace'
          'object'
        elsif name.include? 'View' or name.include? 'TextArea' or name.include? 'TextField' or name.include? 'Checkbox' or name.include? 'Select' or name.include? 'InjectedProperty' or name.include? 'DefaultResolver'
          'view'
        elsif name.include? 'Ember'
          'core'
        else
          'others'
        end
      end

      def additional_entries
        puts 'slug: ' + slug
        if ADDITIONAL_ENTRIES.include? slug
            return ADDITIONAL_ENTRIES[slug]
        end
        css('.item-entry').map do |node|
          heading = node.at_css('h2')
          name = heading.content.strip.tr('#', '.')

          if self.name == 'Handlebars Helpers'
            name << ' (handlebars helper)'
            custom_parsed_uri = get_parsed_uri_by_name(name)
            next [name.tr('#', '.'), heading['id'], type, custom_parsed_uri, get_parsed_uri, get_docset]
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
          custom_parsed_uri = get_parsed_uri_by_name(name)
          [name, heading['id'], get_type, custom_parsed_uri, get_parsed_uri, get_docset]
        end
      end
    end
  end
end

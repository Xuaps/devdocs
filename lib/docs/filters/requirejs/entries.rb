module Docs
  class Requirejs
    class EntriesFilter < Docs::EntriesFilter
      SLUG_ENTRIES = %w(
      api
      optimization
      jquery
      node
      dojo
      commonjs
      plugins
      why
      whyamd)

      def get_name
        puts 'slug: ' + slug
        if at_css('h1')
            name = at_css('h1').content
        else
            name = 'Index'
        end
        name
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
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            parent_uri = 'null'
        end
      end                                         

      def get_type
          if slug.include? 'why' or  slug.include? 'optimization'
              'guide'
          elsif slug.include? 'api'
              'api'
          elsif slug.include? 'jquery' or slug.include? 'commonjs' or slug.include? 'node'
              'guide'
          elsif slug.include? 'plugins'
              'module'
          else
              'others'
          end
      end
      
      def include_default_entry?
        return false if slug == ''
        return true
      end

      def additional_entries
        return [] unless SLUG_ENTRIES.include? slug
        entries = []
        type = nil


        css('*').each do |node|
          if node.name == 'h2'
            next if node == nil
            name = node.content
            custom_parsed_uri = get_parsed_uri_by_name(name)
            id = node['id']
            entries << [name, id, 'guide', custom_parsed_uri, get_parent_uri, get_docset]
          elsif (node.name == 'h3' || node.name == 'h4') && node.content.strip !=''
            name = node.content
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['id'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
          end
        end

        css('p[id^="config-"]').each do |node|
          next if node['id'].include?('note')
          name = node.at_css('strong').content
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], 'configuration', custom_parsed_uri, get_parent_uri, get_docset]
        end
        entries
      end
    end
  end
end

module Docs
  class Java7se
    class EntriesFilter < Docs::ReflyEntriesFilter
      EXCLUDED_SLUGS = [
        'allclasses-noframe', 
        'overview-tree',
        'constant-values',
        'deprecated-list',
        'Nokogiri',
        'java/applet/package-summary',
        'index-files/index-1'
      ]

      def get_name
        if css('ul.inheritance li').to_s != ''
          name = css('ul.inheritance li').last.content.strip
        elsif css('h2.title').to_s != ''
          name = css('h2.title').first.content.strip
        elsif css('h1').to_s != ''
          name = css('h1').first.content.strip
        else
          name = slug
        end
        name = name.gsub('Uses of Class', 'Uses of Class ')
        name = name.gsub(/<.*>/, '')
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name)
        end
        parsed_uri
      end

      def get_parsed_uri_by_name(name)
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(name)
        end
        parsed_uri
      end

      def get_parent_uri
        parent_uri = context[:docset_uri]
        css('ul.inheritance li a:first-child').each do |node|
           link = node.content.strip.gsub(/<.>/, '')
           parent_uri += '/' + self.urilized(link)
        end
        if parent_uri == context[:docset_uri]
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        type = 'others'
        if css('h2.title').to_s != ''
          type = css('h2.title').first.content.strip.downcase.split(' ').first
        end
        type
      end

      # def additional_entries
      #   entries = []
      #   css('span[name]').each do |node|
      #       name = node['name']
      #       name = name.capitalize.tr('_', ' ') if name.upcase != name
      #       custom_parsed_uri = get_parsed_uri_by_name(name)
      #       entries << [name, node['name'], get_type, custom_parsed_uri, get_parent_uri, get_docset]
      #   end

      #   entries
      # end

      def include_default_entry?
        return false if EXCLUDED_SLUGS.include? slug
        return true
      end
    end
  end
end

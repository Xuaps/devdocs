module Docs
  class Chai
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        at_css('h1').content
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + path.sub('/index','')
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
        if path.include? 'assert'
            'assert'
        elsif path.include? 'bdd'
             'function'
        elsif path.include? 'plugin'
             'object'
        elsif path.include? 'installation'
             'guide'
        else
             'others'
        end
      end

      def additional_entries
        css('.antiscroll-inner a').each_with_object [] do |node, entries|
          id = node['href'].remove('#') + '-section'
          name = node.content.strip.split(' / ')[0]
          custom_parsed_uri = get_parent_uri + '#' + id
          entries << [name, id, type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

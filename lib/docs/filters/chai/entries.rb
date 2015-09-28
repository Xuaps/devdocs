module Docs
  class Chai
    class EntriesFilter < Docs::ReflyEntriesFilter

      def get_name
        at_css('h1').content
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        parsed_uri
      end

      def get_parsed_uri_by_name(name)
        parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        parsed_uri
      end

      def get_parent_uri
        parent_uri = 'null'
      end

      def get_type
        if path.include? 'assert'
            'assert'
        elsif path.include? 'bdd'
             'function'
        elsif path.include? 'plugin'
             'plugin'
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
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, id, type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

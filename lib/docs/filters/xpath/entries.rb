module Docs
  class Xpath
    class EntriesFilter < Docs::EntriesFilter
      EXCLUDED_PATH = ['MDN','Web technology for developers', 'XPath']
      def get_name
        name = super
        name.remove!('Axes.')
        name << '()' if name.gsub!('Functions.', '')
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

      def get_parent_uri
        parent_uri = context[:docset_uri]
        xpath('//nav[@class="crumbs"]//a/text()').each do |node|
           link = node.content.strip
           if not EXCLUDED_PATH.include? link
              parent_uri += '/' + self.urilized(link)
           end
        end
        if parent_uri == context[:docset_uri]
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        if slug.start_with?('Axes')
          'axes'
        elsif slug.start_with?('Functions')
          'function'
        else
          'others'
        end
      end
    end
  end
end

module Docs
  class Mysql
    class EntriesFilter < Docs::ReflyEntriesFilter

      EXCLUDED_PATH = ['MySQL 5.7 Reference Manual']

      def get_name
        # puts css('.title').first.content
        name = css('.title').first.content.remove('Chapter ', 'Appendix B', 'Appendix A', 'Appendix E', 'Appendix D','Appendix', ' E ', 'D.', 'A.', 'E.', 'B.').gsub(/\A[\d*\.]*/, "").strip
        # puts name
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
        if css('#hidden-breadcrumbs').to_s != ''
          xpathsearch = '//span[@id="hidden-breadcrumbs"]//a/text()'
        else
          xpathsearch = '//div[@id="docs-breadcrumbs"]//a/text()'
        end
        xpath(xpathsearch).each do |node|
           link = node.content.gsub(/\A[\d*\.]*/, "").remove('::').strip
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
        type = 'others'
        xpath('//div[@id="docheader"]//a/text()').each do |node|
           link = node.content.remove('::').strip
           if not EXCLUDED_PATH.include? link
              type = link
           end
        end
        if type.include? 'Function' or type.include? 'Math' or type.include? 'Spatial' or type.include? 'Unicode' or type.include? 'Transactions' or type.include? 'Cursors'
          type = 'function'
        elsif type.include? 'Optimizing' or type.include? 'Limits' or type.include? 'Questions' or type.include? 'Performance'
          type = 'guide'
        elsif type.include? 'Optimization' or type.include? 'Optimizer' or type.include? 'Information' or type.include? 'Unicode'
          type = 'guide'
        elsif type.include? 'Type' or type.include? 'InnoDB' or type.include? 'MyISAM' or type.include? 'Globalization' or type.include? 'Globalization' or type.include? 'Character' or type.include? 'Collation'
          type = 'type'
        elsif type.include? 'Statement' or type.include? 'Syntax'
          type = 'statement'
        elsif type.include? 'Operators'
          type = 'operator'
        elsif type.include? 'Variable' or type.include? 'Literal'
          type = 'data'
        elsif type.include? 'OpenGIS'
          type = 'class'
        elsif type.include? 'Utility' or  type.include? 'Plugins'
          type = 'utils'
        elsif type.include? 'MySQL' or type.include? 'Server' or type.include? 'Storage' or type.include? 'Replication'
          type = 'guide'
        end
        type
      end
    end
  end
end

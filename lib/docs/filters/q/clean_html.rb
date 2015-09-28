module Docs
  class Q
    class CleanHtmlFilter < Docs::ReflyFilter
      def call
        css('.anchor').each do |node|
          node.parent['id'] = node['href'].remove('#')
          node.remove
        end

        css('.highlight > pre').each do |node|
          node.content = node.content.gsub('    ', '  ')
        end
        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _q'
        doc
      end
    end
  end
end

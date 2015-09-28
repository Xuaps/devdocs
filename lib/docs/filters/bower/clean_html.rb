module Docs
  class Bower
    class CleanHtmlFilter < Docs::ReflyFilter
      def call
        title = at_css('.page-title')
        @doc = at_css('.main')

        css('.site-footer').remove

        css('.highlight').each do |node|
          node.name = 'pre'
          node['data-lang'] = node.at_css('[data-lang]')['data-lang']
          node.content = node.content
        end
        WrapPreContentWithCode 'hljs cpp'
        WrapContentWithDivs '_page _bower'
        doc
      end
    end
  end
end

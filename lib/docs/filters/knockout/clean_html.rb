module Docs
  class Knockout
    class CleanHtmlFilter < Docs::ReflyFilter
      def call
        root_page? ? root : other
        @doc['class'] = ''
        css('pre > code').each do |node|
          node.before(node.children).remove
        end
        WrapPreContentWithCode 'hljs actionscript'
        WrapContentWithDivs '_page _knockout'
        doc
      end

      def root
        @doc = at_css '.content'
        at_css('h1').content = 'Knockout.js'
      end

      def other
        css('h1 ~ h1').each do |node|
          node.name = 'h2'
        end

        css('.liveExample').each do |node|
          node.content = 'Live examples are not available on DevDocs, sorry.'
        end
      end
    end
  end
end

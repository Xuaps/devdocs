module Docs
  class Markdown
    class CleanHtmlFilter < Docs::ReflyFilter
      def call
        at_css('h1').content = 'Markdown'

        css('#ProjectSubmenu', 'hr').remove

        css('pre > code').each do |node|
          node.before(node.children).remove
        end

        WrapPreContentWithCode 'hljs asciidoc'
        WrapContentWithDivs '_page _markdown'
        doc
      end
    end
  end
end

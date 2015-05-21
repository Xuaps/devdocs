module Docs
  class Markdown
    class CleanHtmlFilter < Filter
      def call
        at_css('h1').content = 'Markdown'

        css('#ProjectSubmenu', 'hr').remove

        css('pre > code').each do |node|
          node.before(node.children).remove
        end

        doc = WrapContentWithDivs('_page _markdown',@doc)
        doc
      end
    end
  end
end

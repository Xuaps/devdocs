module Docs
  class Express
    class CleanHtmlFilter < Docs::ReflyFilter
      def call
        css('section', 'div.highlighter-rouge').each do |node|
          node.before(node.children).remove
        end


        # Put id attributes on headings
        css('h2', 'h3', 'h4').each do |node|
          node['id'] = node.content.downcase.tr(' ', '-')
        end

        css('table[border]').each do |node|
          node.remove_attribute 'border'
        end

        # Remove code highlighting
        css('figure.highlight').each do |node|
          node['data-language'] = node.at_css('code[data-lang]')['data-lang']
          node.content = node.content
          node.name = 'pre'
        end

        css('pre > code').each do |node|
          node.parent['data-language'] = node['class'][/language-(\w+)/, 1] if node['class']
          node.parent.content = node.parent.content
        end
        WrapPreContentWithCode 'hljs actionscript'
        WrapContentWithDivs '_page _express'
        doc
      end
    end
  end
end

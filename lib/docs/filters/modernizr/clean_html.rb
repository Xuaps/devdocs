module Docs
  class Modernizr
    class CleanHtmlFilter < Docs::ReflyFilter
      def call
        css('pre').each do |node|
          node.content = node.content
        end

        css('> div', '> section').each do |node|
          node.before(node.children).remove
        end

        css('h3, h4').each do |node|
          node.name = node.name.sub(/\d/) { |i| i.to_i - 1 }
        end

        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _modernizr'
        doc
      end
    end
  end
end

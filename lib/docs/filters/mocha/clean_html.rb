module Docs
  class Mocha
    class CleanHtmlFilter < Docs::ReflyFilter
      def call
        doc.child.remove until doc.child['id'] == 'installation'

        css('pre').each do |node|
          node.content = node.content
        end
        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _mocha'
        doc
      end
    end
  end
end

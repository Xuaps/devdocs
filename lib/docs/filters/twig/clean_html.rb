module Docs
  class Twig
    class CleanHtmlFilter < Docs::ReflyFilter
      def call
        WrapPreContentWithCode 'hljs php'
        WrapContentWithDivs '_page _twig'
        css('.header', '#footer').remove
        css('.content').each do |node|
          node['class'] = ''
        end
        css('abbr').each do |node|
          node.name = 'span'
        end
        doc
      end
    end
  end
end

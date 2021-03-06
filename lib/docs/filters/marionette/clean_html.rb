module Docs
  class Marionette
    class CleanHtmlFilter < Docs::ReflyFilter
      def call
        root_page? ? root : other
        WrapPreContentWithCode 'hljs actionscript'
        WrapContentWithDivs '_page _marionette'
        doc
      end

      def root
        at_css('p').remove
      end

      def other
        css('#source + h2', '#improve', '#source', '.glyphicon').remove

        css('pre > code').each do |node|
          node.before(node.children).remove
        end

        css('h2', 'h3').each do |node|
          id = node.content.strip
          id.downcase!
          id.remove! %r{['"\/\.:]}
          id.gsub! %r{[\ _]}, '-'
          node['id'] = id
        end
      end
    end
  end
end

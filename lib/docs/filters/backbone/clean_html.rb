module Docs
  class Backbone
    class CleanHtmlFilter < Filter
      def call
        # Remove Introduction, Upgrading, etc.
        while doc.child['id'] != 'Events'
          doc.child.remove
        end

        # Remove Examples, FAQ, etc.
        while doc.children.last['id'] != 'faq'
          doc.children.last.remove
        end

        css('#faq', '.run').remove

        css('tt').each do |node|
          node.name = 'pre'
        end

        css('code').each do |node|
          node.name = 'pre'
        end

        css('pre').each do |node|
          node['class'] = 'runnable  language-javascript'
        end
        doc = WrapContentWithDivs('_page _underscore',@doc)
        doc
      end
    end
  end
end

module Docs
  class Backbone
    class CleanHtmlFilter < Filter
      def call
        #change the classname to avoid conflicts with css classes
        doc['class'] = 'cnt'
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

        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _underscore'
        doc
      end
    end
  end
end

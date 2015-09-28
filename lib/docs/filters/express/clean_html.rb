module Docs
  class Express
    class CleanHtmlFilter < Docs::ReflyFilter
      def call
        at_css('h1').remove

        css('section').each do |node|
          node.before(node.children).remove
        end

        # Put id attributes on headings
        css('h2 + a[name]').each do |node|
          node.previous_element['id'] = node['name']
          node.remove
        end

        css('table[border]').each do |node|
          node.remove_attribute 'border'
        end

        # Remove code highlighting
        css('pre').each do |node|
          node.content = node.content
        end
        WrapPreContentWithCode 'hljs actionscript'
        WrapContentWithDivs '_page _express'
        doc
      end
    end
  end
end

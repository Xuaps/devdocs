module Docs
  class Sass
    class CleanHtmlFilter < Docs::ReflyFilter
      def call
        css('tt').each do |node|
          node.name = 'code'
        end

        root_page? ? root : other

        WrapPreContentWithCode 'hljs css'
        WrapContentWithDivs '_page _yard'
        doc
      end

      def root
        at_css('.maruku_toc').remove
        css('a[href]').each do |node|
            node['href'] = node['href'].sub('../../','')
            if node['href'].include? 'file.sass_reference'
                node['href'] = node['href'].sub('file.sass_reference', 'index')
            end
        end
      end

      def other
        at_css('h2').remove

        css('.showSource', '.source_code').remove

        css('div.docstring', 'div.discussion').each do |node|
          node.before(node.children).remove
        end

        # Remove "See Also"
        css('.see').each do |node|
          node.previous_element.remove
          node.remove
        end

        # Remove "- ([...])" before method names
        css('.signature', 'span.overload', 'span.signature').each do |node|
          next if node.at_css('.overload')
          node.child.remove while node.child.name != 'strong'
        end

        # Clean up .inline divs
        css('div.inline').each do |node|
          node.content = node.content
          node.name = 'span'
        end

        css('a[href]').each do |node|
            if node['href'].include? '../'
                node['href'] = node['href'].sub('../../','')
            end
            if node['href'].include? 'file.sass_reference'
                node['href'] = node['href'].sub('file.sass_reference', 'index')
            end
        end

        # Remove links to type classes (e.g. Number)
        css('.type > code').each do |node|
          node.before(node.content.remove('Sass::Script::Value::').remove('Sass::Script::')).remove
        end
      end
    end
  end
end
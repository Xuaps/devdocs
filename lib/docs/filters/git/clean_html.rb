module Docs
  class Git
    class CleanHtmlFilter < Filter
      def call
        root_page? ? root : other
        doc
      end

      def root
        at_css('h1').content = 'Git'
      end

      def other
        css('h1 + h2', '#_git + div', '#_git').remove

        css('> div', 'pre > tt', 'pre > em', 'div.paragraph').each do |node|
          node.before(node.children).remove
        end

        css('> h1').each do |node|
          node.content = node.content.remove(/\(\d\) Manual Page/)
        end

        unless at_css('> h1')
          doc.child.before("<h1>#{slug}</h1>")
        end

        unless at_css('> h2')
          css('> h3').each do |node|
            node.name = 'h2'
          end
        end

        css('h2').each do |node|
          node.content = node.content.capitalize
        end

        css('tt', 'p > em').each do |node|
          node.name = 'code'
        end
        
        # Fix confictive links
        css('a').each do |node|
          if !node['href'].nil?
              node['href'] = node['href'].remove('http://git-scm.com/docs/').remove('/docs/').remove('docs/')
          end
        end

      end
    end
  end
end

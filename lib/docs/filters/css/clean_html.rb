module Docs
  class Css
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = ['text-emphasis-color','en-us/docs/web/guide/prefixes', 'image-resolution']
      def call
        root_page? ? root : other
        doc
      end

      def root
        # Remove "CSS3 Tutorials" and everything after
        css('#CSS3_Tutorials ~ *', '#CSS3_Tutorials').remove
      end

      def other
        # fix links
        css('a[href]').each do |node|
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if BROKEN_LINKS.include? node['href']
              node['class'] = 'broken'
              node['href'] = '/help#brokenlink'
            end
          end

        # Remove "|" and "||" links in syntax box (e.g. animation, all, etc.)
        css('.syntaxbox', '.twopartsyntaxbox').css('a').each do |node|
          if node.content == '|' || node.content == '||'
            node.replace node.content
          end
        end

        end
      end
    end
  end
end

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

        css('a[href]').each do |node|
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if node['href'].start_with? ':'
              node['class'] = 'broken'
              node['href'] = '/help#brokenlink'
            elsif node['href'].start_with? 'howto/'
              node['href'] = 'https://github.com/git/git/blob/master/Documentation/' + node['href'] + '.txt'
            else
              sluglist = slug.split('/')
              nodelist = node['href'].split('/')
              newhref = []
              nodelist.each do |item|
                if item == '..'
                  sluglist.pop
                else
                  newhref << item
                end
              end
              sluglist.pop
              if sluglist.size>0
                node['href'] = sluglist.join('/') + '/' + newhref.join('/')
              else
                node['href'] = newhref.join('/')
              end
            end
          end
        end

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

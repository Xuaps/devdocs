module Docs
  class Css
    class CleanHtmlFilter < Docs::ReflyFilter
      BROKEN_LINKS = [
          'en-us/docs/web/guide/prefixes',
          'counter',
          'en-us/docs/css/inheritance',
          '@page/size',
          'transform-function/transform-origin'
      ]
      REPLACED_LINKS = {
        '%40charset' => '@charset',
        '%40import' => '@import'
      }

      def call
        root_page? ? root : other
        WrapPreContentWithCode 'hljs css'
        doc
      end

      def root
        # Remove "CSS3 Tutorials" and everything after
        css('footer','div.article-meta', '#wiki-left', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove
        css('#CSS3_Tutorials ~ *', '#CSS3_Tutorials').remove
      end

      def other
        #Cleaning content
        css('footer','div.article-meta', '#wiki-left', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove
        # fix links
        css('a[href]').each do |node|
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['title'] = ''
            elsif REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']
            elsif BROKEN_LINKS.include?node['href'].downcase.remove! '../'
              node['class'] = 'broken'
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
              if node['href'] == 'index'
                node['href'] = 'reference'
              elsif REPLACED_LINKS[node['href'].downcase.remove! '../']
                node['href'] = REPLACED_LINKS[node['href'].remove '../']
              end
            end
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

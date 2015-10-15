module Docs
  class Html
    class CleanHtmlFilter < Docs::ReflyFilter

      BROKEN_LINKS = [
          'en-us/docs/web/guide/prefixes',
          'tutorials',
          'portfolio',
          'element/decorator',
          'element/en-us/docs/web/api/htmltableheadercellelement',
          'screen/en/dom/window.screen.top'
      ]
      REPLACED_LINKS = {
        'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/element/en-US/docs/Web/API/HTMLTableHeaderCellElement' => '',
        'en-us/docs/web/api/htmltableheadercellelement' => 'https://developer.mozilla.org/en-US/docs/Web/API/HTMLTableHeaderCellElement',
        'strict_mode' => 'strict_mode'
      }

      def call
        root_page? ? root : other
        WrapPreContentWithCode 'hljs html'
        doc
      end

      def root
        #Cleaning content
        css('footer','div.article-meta', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove
        css('p').each do |node|
          node.remove if node.content.lstrip.start_with? 'The symbol'
        end
      end

      def other
        #Cleaning content
        css('footer','div.article-meta', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase.remove '_(event)'
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']          
          elsif !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'mailto:'
            if node['class'] == 'new' or node['title'] == 'The documentation about this has not yet been written; please consider contributing!'
              node['class'] = 'broken'
              node['title'] = ''
              # node['href'] = context[:domain] + '/help#brokenlink'
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              # node['href'] = context[:domain] + '/help#brokenlink'
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
      end

    end
  end
end

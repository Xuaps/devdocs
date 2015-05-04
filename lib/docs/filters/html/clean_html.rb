module Docs
  class Html
    class CleanHtmlFilter < Filter

      BROKEN_LINKS = [
          'en-us/docs/web/guide/prefixes',
          'tutorials',
          'element/decorator',
          'element/en-us/docs/web/api/htmltableheadercellelement'
      ]
      def call
        root_page? ? root : other
        doc
      end

      def root
        #Cleaning content
        css('footer','div.article-meta', '.submenu', 'div.wiki-block', 'nav').remove
        css('p').each do |node|
          node.remove if node.content.lstrip.start_with? 'The symbol'
        end
      end

      def other
        #Cleaning content
        css('footer','div.article-meta', '.submenu', 'div.wiki-block', 'nav').remove
        css('a[href]').each do |node|
          if node['href'] == 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/element/en-US/docs/Web/API/HTMLTableHeaderCellElement' or node['href'].downcase == 'en-us/docs/web/api/htmltableheadercellelement'
              node['href'] = 'https://developer.mozilla.org/en-US/docs/Web/API/HTMLTableHeaderCellElement'
          end
          node['href'] = CleanWrongCharacters(node['href']).remove '_(event)'
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['href'] = '/help#brokenlink'
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              node['href'] = '/help#brokenlink'
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

      def CleanWrongCharacters(href)
          href.gsub('%23', '#').gsub('%28', '(').gsub('%29', ')').gsub('%21', '!').gsub('%7b', '{').gsub('%7e', '~').gsub('%2a', '*').gsub('%2b', '+').gsub('%3d', '=')
      end
    end
  end
end

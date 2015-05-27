module Docs
  class Xpath
    class CleanHtmlFilter < Filter

      BROKEN_LINKS = [
          'en/xslt/decimal-format',
          'en/xslt/key'
      ]

      def call
        root_page? ? root : other
        WrapPreContentWithCode 'hljs javascript'
        doc
      end

      def root
        if table = at_css('.topicpage-table')
          table.after(table.css('td').children).remove
        end
        css('footer','div.article-meta', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove
      end

      def other

        #Cleaning content
        css('footer','div.article-meta', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href'])
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if node['class'] == 'new'
              node['class'] = 'broken'
              # node['href'] = context[:domain] + '/help#brokenlink'
            elsif BROKEN_LINKS.include?node['href'].downcase.remove!
              node['class'] = 'broken'
              # node['href'] = context[:domain] + '/help#brokenlink'
            elsif !node['href'].start_with? '#'
              sluglist = slug.split('/')
              nodelist = node['href'].split('/')
              newhref = []
              nodelist.each do |item|
                if item == '..'
                  sluglist.pop
                elsif item == 'en'
                  sluglist.pop
                elsif item == 'xpath'
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
        css('div[style*="background: #f5f5f5;"]').remove

        css('h3[id]').each do |node|
          node.name = 'h2'
        end

        css('p').each do |node|
          child = node.child
          child = child.next while child && child.text? && child.content.blank?
          child.remove if child.try(:name) == 'br'
        end
      end
      def CleanWrongCharacters(href)
          href.gsub('%23', '#').gsub('%28', '(').gsub('%29', ')').gsub('%21', '!').gsub('%7b', '{').gsub('%7e', '~').gsub('%2a', '*').gsub('%2b', '+').gsub('%3d', '=')
      end
    end
  end
end

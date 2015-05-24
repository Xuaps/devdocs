module Docs
  class Javascript
    class CleanHtmlFilter < Filter
      
      BROKEN_LINKS = [
          'en-us/docs/web/guide/prefixes'
      ]
      REPLACED_LINKS = {
          'functions/strict_mode' => 'strict_mode',
          'strict_mode' => 'strict_mode'

      }
      def call
        root_page? ? root : other
        doc
      end

      def root
        #Cleaning content
        css('footer','div.article-meta', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove

        # Remove heading links
        css('h2 > a').each do |node|
          node.before(node.content)
          node.remove
        end
      end

      def other
        #Cleaning content
        css('footer','div.article-meta', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).remove '_(event)'
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'mailto:'
            # puts 'nodeini: ' + node['href']
            if node['class'] == 'new'
              node['class'] = 'broken'
              # node['href'] = context[:domain] + '/help#brokenlink'
            elsif REPLACED_LINKS[node['href'].remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove! '../']
            elsif BROKEN_LINKS.include?node['href'].downcase.remove! '../'
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
            # puts 'nodefin: ' + node['href']
          end
        end

        # Remove "style" attribute
        css('.inheritsbox', '.overheadIndicator').each do |node|
          node.remove_attribute 'style'
        end

        # Remove <div> wrapping .overheadIndicator
        css('div > .overheadIndicator:first-child:last-child').each do |node|
          node.parent.replace(node)
        end
      end
      def CleanWrongCharacters(href)
          href.gsub('%23', '#').gsub('%28', '(').gsub('%29', ')').gsub('%21', '!').gsub('%7b', '{').gsub('%7e', '~').gsub('%2a', '*').gsub('%2b', '+').gsub('%3d', '=')
      end
    end
  end
end

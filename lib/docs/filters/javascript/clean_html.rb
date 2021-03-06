module Docs
  class Javascript
    class CleanHtmlFilter < Docs::ReflyFilter
      
      BROKEN_LINKS = [
          'en-us/docs/web/guide/prefixes',
          'global_objects/simd/clamp',
          'webkit_nightly'
      ]
      REPLACED_LINKS = {
          'functions/strict_mode' => 'strict_mode',
          'strict_mode' => 'strict_mode'

      }
      def call
        root_page? ? root : other
        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _javascript'
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
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['title'] = ''
            elsif REPLACED_LINKS[node['href'].remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove! '../']
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
            end
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
    end
  end
end

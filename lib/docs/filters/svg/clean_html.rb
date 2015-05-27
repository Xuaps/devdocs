module Docs
  class Svg
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = [
      ]
      REPLACED_LINKS = {
          'index' => 'element'
      }
      def call
        root_page? ? root : other
        WrapPreContentWithCode 'hljs javascript'
        doc
      end

      def root
        css('footer','div.article-meta', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove
        doc.inner_html = doc.at_css('#Documentation + dl').to_html
      end 

      def other
        css('.prevnext').remove
        css('footer','div.article-meta', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).remove '_(event)'
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if node['class'] == 'new'
              node['class'] = 'broken'
              # node['href'] = context[:domain] + '/help#brokenlink'
            elsif BROKEN_LINKS.include?node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              # node['href'] = context[:domain] + '/help#brokenlink'
            elsif REPLACED_LINKS[node['href'].remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove! '../']
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

        if at_css('p').content.include?("\u{00AB}")
          at_css('p').remove
        end

        if slug == 'Attribute' || slug == 'Element'
          at_css('h2').name = 'h1'
        end

        css('#SVG_Attributes + div[style]').each do |node|
          node.remove_attribute('style')
          node['class'] = 'index'
          css('h3').each { |n| n.name = 'span' }
        end
      end
    end
  end
end

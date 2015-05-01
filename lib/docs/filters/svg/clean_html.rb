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
        doc
      end

      def root
        doc.inner_html = doc.at_css('#Documentation + dl').to_html
      end 

      def other
        css('.prevnext').remove
        css('.article-meta', '#main-nav', '.wiki-block contributors', '.oauth-login-picker','.wiki-block', '.column-container p bdi').remove
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).remove '_(event)'
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['href'] = '/help#brokenlink'
            elsif BROKEN_LINKS.include?node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              node['href'] = '/help#brokenlink'
            elsif REPLACED_LINKS[node['href'].remove! '../']
              node['class'] = REPLACED_LINKS[node['href'].remove! '../']
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
      def CleanWrongCharacters(href)
          href.gsub('%23', '#').gsub('%28', '(').gsub('%29', ')').gsub('%21', '!').gsub('%7b', '{').gsub('%7e', '~').gsub('%2a', '*').gsub('%2b', '+').gsub('%3d', '=')
      end
    end
  end
end

module Docs
  class DomEvents
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = [
          'en-us/docs/web/guide/prefixes',
          'en-us/dom/touch_events'
      ]

      def call
        css('footer','div.article-meta', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).remove '_(event)'
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['href'] = context[:domain] + '/help#brokenlink'
            elsif BROKEN_LINKS.include?node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              node['href'] = context[:domain] + '/help#brokenlink'
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

        root_page? ? root : other
        doc
      end

      def root
        # Remove parapraph mentioning non-standard events
        at_css('#Standard_events').previous_element.remove

        # Remove everything after "Standard events"
        css('.standard-table ~ *').remove
        # Remove events we don't want
        css('tr').each do |tr|
          if td = tr.at_css('td:nth-child(3)')
            tr.remove if td.content =~ /SVG|Battery|Gamepad|Sensor/i
          end
        end
      end

      def other
        #Cleaning content
        css('footer','div.article-meta', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove

        css('#General_info + dl').each do |node|
          node['class'] = 'eventinfo'
        end
      end
    end
  end
end

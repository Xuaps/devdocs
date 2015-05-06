module Docs
  class Dom
    class CleanHtmlFilter < Filter

      BROKEN_LINKS = [
          'en-us/docs/web/guide/prefixes'
      ]
      REPLACED_LINKS = {
        'float32array' => 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Float32Array',
        'uint8array'   => 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint8Array',
        'boolean'      => 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Boolean'
      }
      def call
        root_page? ? root : other
        doc
      end

      def root
        #Cleaning content
        css('.center','.column-container').remove

      end

      def other
        #Cleaning content
        css('.center','.column-container').remove

        # fix links
        css('a[href]').each do |node|
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['href'] = context[:domain] + '/help#brokenlink'
            elsif BROKEN_LINKS.include?node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              node['href'] = context[:domain] + '/help#brokenlink'
            elsif REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].downcase.remove! '../']
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

        # Bug fix: HTMLElement.offsetWidth
        css('#offsetContainer .comment').remove

        # Bug fix: CompositionEvent, DataTransfer, etc.
        if (div = at_css('div[style]')) && div['style'].include?('border: solid #ddd 2px')
          div.remove
        end

        # Remove double heading on SVG pages
        if slug.start_with? 'SVG'
          at_css('h2:first-child').try :remove
        end

        # Remove <div> wrapping .overheadIndicator
        css('div > .overheadIndicator:first-child:last-child').each do |node|
          node.parent.replace(node)
        end
      end
    end
  end
end

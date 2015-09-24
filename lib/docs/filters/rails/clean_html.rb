module Docs
  class Rails
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = [
        'rdoc-ref:httphelpers'
      ]
      REPLACED_LINKS = {
      }
      def call
        css('.box_info').remove
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href'])
          if REPLACED_LINKS[node['href'].downcase]
              node['href'] = REPLACED_LINKS[node['href']]
          elsif !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if node.content.strip.include? "\u{00B6}" or node['href'] == '#top'
              node.remove
            elsif node['href'].downcase.include? '/doc/syntax'
              node['class'] = 'broken'
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
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

        root_page? ? root : other

        WrapPreContentWithCode 'hljs ruby'
        WrapContentWithDivs '_page _rdoc'
        doc

      end

      def root
      end

      def other
      end
    end
  end
end
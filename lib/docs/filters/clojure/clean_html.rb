module Docs
  class Clojure
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = []
      REPLACED_LINKS = {}
      def call

        @doc = at_css('#content-tag')

        at_css('h1').content = slug.remove('-api')

        css('> div').each do |node|
          node.before(node.children).remove
        end

        css('div > h2', 'div > h3').each do |node|
          node.parent.before(node.parent.children).remove
        end

        css('#proto-type', '#var-type', '#type-type').each do |node|
          node.previous_element << node
          node['class'] = 'type'
        end

        css('.proto-added', '.var-added', '.proto-deprecated', '.var-deprecated').each do |node|
          node.content = node.content
          node.name = 'p'
        end

        css('.proto-added', '.var-added').each do |node|
          if node.content == node.next_element.try(:content)
            node.remove
          end
        end

        css('hr', 'br:first-child', 'pre + br', 'h1 + br', 'h2 + br', 'h3 + br', 'p + br', 'br + br').remove
        WrapPreContentWithCode 'hljs c'
        WrapContentWithDivs '_page _clojure'
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase.remove '_(event)'
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']          
          elsif !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'mailto:'
            if node['class'] == 'new'
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
        doc
      end
    end
  end
end

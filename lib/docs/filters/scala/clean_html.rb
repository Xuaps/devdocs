module Docs
  class Scala
    class CleanHtmlFilter < Docs::ReflyFilter

      BROKEN_LINKS = ['concurrent/forkjoin','traversable']
      REPLACED_LINKS = {
        'collection/immutable/mutable/setlike' => 'collection/mutable/setlike',
        'mutable/setlike' => 'collection/mutable/setlike'
      }
      def call
        css('#comment', '#value', '#definition', '#mbrsel', '#inheritedMembers', '#groupedMembers', '#footer', '#tooltip', '.permalink').remove
        xpath("//div[@class='toggleContainer block']","//div[@class='toggleContainer block diagram-container']").remove
        xpath("//div[@class='toggleContainer block']","//div[@class='toggleContainer block diagram-container']").remove
        WrapPreContentWithCode 'hljs scala'
        WrapContentWithDivs '_page _scala'
        fixLinks
        doc
      end
      def fixLinks
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']          
          elsif !node['href'].start_with? 'http://' and !node['href'].start_with? '#' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'news://' and !node['href'].start_with? 'mailto:'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['title'] = ''
            else
              # puts 'ini: ' + node['href']
              sluglist = slug.split('/')
              if context[:url].to_s.include? '.html'
                sluglist.pop
              end
              nodelist = sluglist + node['href'].split('/')
              newhref = []
              nodelist.each do |item|
                if item == '..'
                  newhref.pop
                elsif item != ''
                  newhref << item
                end
              end
              node['href'] = newhref.join('/')
            end
          end
          if BROKEN_LINKS.include? node['href'].downcase.remove! '../'
            node['class'] = 'broken'
          end
          node['href'] = REPLACED_LINKS[node['href']] || node['href']
        end
        
      end

    end
  end
end

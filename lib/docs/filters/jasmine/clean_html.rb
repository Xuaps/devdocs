module Docs
  class Jasmine
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = []
      REPLACED_LINKS = {}
      def call

        css('.title-banner', '.jump_to', '.pilwrap').remove
        #changing tables for divs
        css('table', 'tr', 'thead', 'td').each do |node|
          node.name = 'div'
        end

        css('h4', 'h3', 'h2').each do |node|
          node.parent.parent['id'] = node.content.capitalize.strip.tr(' ', '_')
        end
        fixLinks
        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _jasmine'
        doc
      end
      def fixLinks
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']          
          elsif !node['href'].start_with? '#' and !node['href'].start_with? 'http://' and !node['href'].start_with? '#' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'news://' and !node['href'].start_with? 'mailto:'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['title'] = ''
            else
              sluglist = slug.split('/')
              if context[:url].to_s.include? '.html'
                sluglist.pop
              end
              nodelist = sluglist + node['href'].split('/')
              newhref = []
              nodelist.each do |item|
                if item == '..'
                  newhref.pop
                elsif item != '' and !newhref.include? item 
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

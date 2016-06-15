module Docs
  class Symfony
    class CleanHtmlFilter < Docs::ReflyFilter

      BROKEN_LINKS = []
      REPLACED_LINKS = {
        'classes' => 'symfony/component/browserkit',
        'index' => 'symfony/component/finder/adapter/abstractadapter'
      }
      def call
        css('.location', '#footer').remove

        css('.header > h1').each do |node|
          node.content = 'Symfony' if root_page?
          node.parent.before(node).remove
        end

        css('div.details').each do |node|
          node.before(node.children).remove
        end

        css('a > abbr').each do |node|
          node.parent['title'] = node['title']
          node.before(node.children).remove
        end

        css('h1 > a', '.content', 'h3 > code', 'h3 strong', 'abbr').each do |node|
          node.before(node.children).remove
        end
        fixLinks
        WrapPreContentWithCode 'hljs php'
        WrapContentWithDivs '_page _symfony'
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

module Docs
  class Vue
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = []
      REPLACED_LINKS = {
        'guide/api/index' => 'api/index',
        'guide/guide/filters' => 'api/filters'
      }
      def call
        @doc = at_css('.content')

        at_css('h1').content = 'Vue.js' if root_page?

        css('#demo').remove

        # Remove code highlighting
        css('figure').each do |node|
          node.name = 'pre'
          node.content = node.at_css('td.code pre').css('.line').map(&:content).join("\n")
        end
        fixLinks
        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _vue'
        doc
      end

      def fixLinks
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase.gsub('guide\/guide','guide')
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
              # only for this docset
              if node['href'].start_with? 'guide'
                nodelist = node['href'].split('/')
              else
                nodelist = sluglist + node['href'].split('/')
              end
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

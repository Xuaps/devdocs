module Docs
  class Browserify
    class CleanHtmlFilter < Docs::ReflyFilter
      BROKEN_LINKS = []
      REPLACED_LINKS = {
        'readme.markdown/changelog.markdown/index' => 'https://github.com/substack/node-browserify/blob/master/changelog.markdown'
      }
      def call
        css('.anchor').each do |node|
          node.parent['id'] = node['href'].remove('#')
          node.remove
        end
        css('p a img').remove
        css('.highlight > pre').each do |node|
          node.content = node.content.gsub('    ', '  ')
        end
        fixLinks
        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _browserify'
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
              # if slug == 'docs/README.md'
              #   sluglist.pop
              # end
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

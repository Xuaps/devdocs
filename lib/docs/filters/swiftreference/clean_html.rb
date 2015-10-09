module Docs
  class Swiftreference
    class CleanHtmlFilter < Docs::ReflyFilter
      BROKEN_LINKS = []
      REPLACED_LINKS = {
        'thebasics' => 'index',
        'https:/developer.apple.com/library/watchos/documentation/cocoa/reference/foundation/classes/nsarray_class/index.html' => 'https://developer.apple.com/library/watchos/documentation/cocoa/reference/foundation/classes/nsarray_class/index.html'
      }
      def call
        css('.copyright', '.metadata-table').remove
        css('h3.section-name').each do |node|
          node['id'] = node.content.downcase.tr ' ', '-'
        end
        css('code.code-voice').each do |node|
          if node.parent.name != 'code'
            node['class'] = ''
            node.name = 'span'
          end
        end
        css('div.Swift').each do |node|
          node.name = 'pre'
        end

        fixLinks
        WrapPreContentWithCode 'hljs swift'
        WrapContentWithDivs '_page _swift'
        doc
      end
      def fixLinks
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase
          node['href'] = node['href'].gsub /#\/\/.*/, ''
          if node.parent['class'] == 'n' or node.parent.parent['class'] == 'para'
            node['href'] = '../' + node['href']
          end
          if node['href'] == ''
            node.name = 'span'
            next
          end
          # puts 'ini: ' + node['href']
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
          # puts 'fin: ' + node['href']
        end
      end
    end
  end
end

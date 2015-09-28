module Docs
  class Opentsdb
    class CleanHtmlFilter < Docs::ReflyFilter

      BROKEN_LINKS = [
        '_images/aggregation_average.png'
      ]
      REPLACED_LINKS = {}
      def call
        @doc = at_css('.documentwrapper > .bodywrapper > .body > .section')

        css('> .section').each do |node|
          node.before(node.children).remove
        end

        css('tt.literal').each do |node|
          node.name = 'code'
          node.content = node.content
        end

        css('div[class*=highlight] .highlight pre').each do |node|
          node.parent.parent.before(node)
          node.content = node.content.gsub('    ', '  ')
        end

        css('table').remove_attr('border')
        fixLinks
        WrapPreContentWithCode 'hljs stylus'
        WrapContentWithDivs '_page _opentsdb'
        doc
      end
      def fixLinks
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase.remove '_(event)'
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']          
          elsif !node['href'].start_with? 'http://' and !node['href'].start_with? '#' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'news://' and !node['href'].start_with? 'mailto:'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['title'] = ''
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
              node['class'] = 'broken'
            else
              sluglist = slug.split('/')
              if context[:url].to_s.end_with? 'html'
                sluglist.pop
              end
              # if sluglist.size>1
              #   sluglist.pop
              # end
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
        end
      end
    end
  end
end

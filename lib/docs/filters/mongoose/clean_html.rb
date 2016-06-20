module Docs
  class Mongoose
    class CleanHtmlFilter < Docs::ReflyFilter
      
      BROKEN_LINKS = [
        'querycursor'
      ]
      REPLACED_LINKS = {
      }

      def call
        css('hr', '.showcode', '.sourcecode').remove

        if slug == 'api'
          at_css('.controls').after('<h1>Mongoose API</h1>')

          css('.private', '.controls').remove

          css('a + .method').each do |node|
            node.previous_element.replace("<h2>#{node.previous_element.to_html}</h2>")
          end
        else
          at_css('h2').name = 'h1'

          css('h3').each do |node|
            node.name = 'h2'
          end
        end
          # fix links
          css('a[href]').each do |node|
            if node['href'] == 'index'
                node.name = 'span'
            end
            puts node['href']
            node['href'] = CleanWrongCharacters(node['href']).downcase.remove '_(event)'
            if REPLACED_LINKS[node['href'].downcase.remove! '../']
                node['href'] = REPLACED_LINKS[node['href'].remove '../']          
            elsif !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'mailto:'
              if node['class'] == 'new' or node['title'] == 'The documentation about this has not yet been written; please consider contributing!'
                node['class'] = 'broken'
                node['title'] = ''
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
        css('pre > code', 'h1 + ul', '.module', '.item', 'h3 > a', 'h3 code').each do |node|
          node.before(node.children).remove
        end

        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _mongoose'
        doc
      end
    end
  end
end

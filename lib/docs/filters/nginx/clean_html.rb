module Docs
  class Nginx
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = [

      ]
      def call
        at_css('h2').name = 'h1'

        css('center').each do |node|
          node.before(node.children).remove
        end

        css('blockquote > pre', 'blockquote > table:only-child').each do |node|
          node.parent.before(node).remove
        end

        css('a[name]').each do |node|
          node.next_element['id'] = node['name']
          node.remove
        end

        links = css('h1 + table > tr:only-child > td:only-child > a').map(&:to_html)
        if links.present?
          at_css('h1 + table').replace("<ul><li>#{links.join('</li><li>')}</li></ul>")
        end

        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href'])
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if BROKEN_LINKS.include?node['href'].downcase
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

        doc = WrapContentWithDivs('_page _nginx',@doc)
        doc
      end
      def CleanWrongCharacters(href)
          href.gsub('%23', '#').gsub('%28', '(').gsub('%29', ')').gsub('%21', '!').gsub('%7b', '{').gsub('%7e', '~').gsub('%2a', '*').gsub('%2b', '+').gsub('%3d', '=').gsub('%40', '@')
      end
    end
  end
end

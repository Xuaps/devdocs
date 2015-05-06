module Docs
  class Django
    class CleanHtmlFilter < Filter

      BROKEN_LINKS = [
      ]
      REPLACED_LINKS = {
      }
      def call
        @doc = at_css('.yui-g')

        css('a[href]').each do |node|
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            node['href'] = CleanWrongCharacters(node['href'])
            if BROKEN_LINKS.include?node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              node['href'] = context[:domain] + '/help#brokenlink'
            elsif REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].downcase.remove! '../']
            elsif  !node['href'].start_with? 'mailto:'
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


        css('.section', 'a > em').each do |node|
          node.before(node.children).remove
        end

        css('tt', 'span.pre').each do |node|
          node.name = 'code'
          node.content = node.content
          node.remove_attribute 'class'
        end

        css('.headerlink').each do |node|
          id = node['href'][1..-1]
          node.parent['id'] ||= id
          doc.at_css("span##{id}").try(:remove)
          node.remove
        end

        css('h1', 'h2', 'h3', 'dt').each do |node|
          node.content = node.content
        end

        css('div[class^="highlight-"]').each do |node|
          node.name = 'pre'
          node['class'] = case node['class']
            when 'highlight-python' then 'python'
            when 'highlight-html+django' then 'markup'
            else ''
          end
          node.content = node.at_css('pre').content
        end

        doc
      end
    end
  end
end

module Docs
  class React
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = [
        'nativemodulesandroid.md'
      ]
      REPLACED_LINKS = {
        'react/docs/advanced-performance' => 'advanced-performance',
        'docs/docs/jsx-in-depth' => 'docs/jsx-in-depth',
        'docs/docs/tutorial' => 'docs/tutorial'
      }
      def call
        @doc = at_css('.inner-content')

        if root_page?
          at_css('h1').content = 'React Documentation'
        end

        css('.docs-prevnext', '.hash-link', '.edit-page-link').remove

        css('a.anchor').each do |node|
          node.parent['id'] = node['name']
        end

        css('.highlight').each do |node|
          node.name = 'pre'
          node['data-lang'] = node.at_css('[data-lang]')['data-lang']
          node.content = node.content
        end

        css('blockquote > p:first-child').each do |node|
          node.remove if node.content.strip == 'Note:'
        end

        fixLinks
        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _react'
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

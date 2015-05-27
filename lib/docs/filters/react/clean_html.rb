module Docs
  class React
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = [
      ]
      REPLACED_LINKS = {
        'react/docs/advanced-performance' => 'advanced-performance'
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

        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href'])
          if REPLACED_LINKS[node['href'].downcase]
              node['href'] = REPLACED_LINKS[node['href']]
          elsif !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            # puts 'nodeini: ' + node['href']
            if node.content.strip.include? "\u{00B6}" or node['href'] == '#top'
              node.remove
            elsif node['href'].downcase.include? '/doc/syntax'
              node['class'] = 'broken'
              # node['href'] = context[:domain] + '/help#brokenlink'
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
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
            # puts 'nodefin: ' + node['href']
          end
        end
        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _react'
        doc
      end
    end
  end
end

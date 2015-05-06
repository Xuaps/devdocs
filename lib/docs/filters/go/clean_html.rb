module Docs
  class Go
    class CleanHtmlFilter < Filter
      REPLACED_LINKS = {
        '..' => 'index'
      }
      BROKEN_LINKS = [
      ]
      def call
        if root_page?
          at_css('h1').content = 'Go Programming Language'

          # Remove empty columns
          css('tr:first-child + tr', 'th:first-child + th', 'td:first-child + td').remove

          # Remove links to unscraped pages
          css('td + td:empty').each do |node|
            node.previous_element.content = node.previous_element.content
          end
        end
        css('a[href]').each do |node|
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            node['href'] = CleanWrongCharacters(node['href'])
            if BROKEN_LINKS.include? node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              node['href'] = context[:domain] + '/help#brokenlink'
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
              if sluglist.size>0
                node['href'] = sluglist.join('/') + '/' + newhref.join('/')
              else
                node['href'] = newhref.join('/')
              end
            end
          end
        end
        css('#plusone', '#nav', '.pkgGopher', '#footer', '.collapsed').remove

        # Remove triangle character
        css('h2', '.exampleHeading').each do |node|
          node.content = node.content.remove("\u25BE")
          node.name = 'h2'
        end

        # Turn <dl> into <ul>
        css('#short-nav', '#manual-nav').each do |node|
          node.children = node.css('dd').tap { |nodes| nodes.each { |dd| dd.name = 'li' } }
          node.name = 'ul'
        end

        # Remove code highlighting
        css('pre').each do |node|
          node.content = node.content
        end

        # Fix example markup
        css('.play').each do |node|
          node.children = node.at_css('.code').children
          node.name = 'pre'
        end

        doc
      end
      def CleanWrongCharacters(href)
          href.gsub('%23', '#').gsub('%28', '(').gsub('%29', ')').gsub('%21', '!').gsub('%7b', '{').gsub('%7e', '~').gsub('%2a', '*').gsub('%2b', '+').gsub('%3d', '=')
      end
    end
  end
end

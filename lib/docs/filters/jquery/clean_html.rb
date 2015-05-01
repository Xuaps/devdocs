module Docs
  class Jquery
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = [
        'content-grids'
      ]
      REPLACED_LINKS = {
          'stacking-elements' => 'theming/stacking-elements'
      }
      def call
        css('hr', '.icon-link', '.entry-meta').remove

        if css('> article').length == 1
          doc.children = at_css('article').children
        end

        if root_page?
          # Remove index page title
          at_css('.page-title').remove

          # Change headings on index page
          css('h1.entry-title').each do |node|
            node.name = 'h2'
          end
        end

        #fix links
        css('a[href]').each do |node|
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            puts node['href']
            node['href'] = CleanWrongCharacters(node['href']).remove '../'
            if BROKEN_LINKS.include? node['href'].downcase
               node['class'] = 'broken'
               node['href'] = '/help#brokenlink'
            elsif REPLACED_LINKS[node['href'].downcase.remove! '../']
                node['href'] = REPLACED_LINKS[node['href'].remove '../']
            end
          end
        end

        # Remove useless <header>
        css('.entry-header > .entry-title', 'header > .underline', 'header > h2:only-child').to_a.uniq.each do |node|
          node.parent.replace node
        end

        # Remove code highlighting
        css('div.syntaxhighlighter').each do |node|
          node.name = 'pre'
          node.content = node.at_css('td.code').css('div.line').map(&:content).join("\n")
        end

        # jQueryMobile/jqmData, etc.
        css('dd > dl').each do |node|
          node.parent.replace(node)
        end

        doc
      end
      def CleanWrongCharacters(href)
          href.gsub('%23', '#').gsub('%28', '(').gsub('%29', ')').gsub('%21', '!').gsub('%7b', '{').gsub('%7e', '~').gsub('%2a', '*').gsub('%2b', '+').gsub('%3d', '=')
      end
    end
  end
end

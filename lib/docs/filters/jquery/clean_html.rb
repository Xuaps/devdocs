module Docs
  class Jquery
    class CleanHtmlFilter < Docs::ReflyFilter
      BROKEN_LINKS = [
        'content-grids'
      ]
      REPLACED_LINKS = {
          'stacking-elements' => 'theming/stacking-elements',
          'jquery.cssnumer'   => 'jquery.cssnumber'
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
            node['href'] = CleanWrongCharacters(node['href']).remove '../'
            if BROKEN_LINKS.include? node['href'].downcase
               node['class'] = 'broken'
               # node['href'] = context[:domain] + '/help#brokenlink'
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
        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _jquery'
        doc
      end
    end
  end
end

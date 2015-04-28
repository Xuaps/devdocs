module Docs
  class Css
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = %w(
        text-emphasis-color
        en-us/docs/web/guide/prefixes
        image-resolution
        animation-property
        clip-rule
        scroll-snap-points-x
        scroll-snap-points-y
        scroll-snap-destination
        scroll-snap-coordinate
        text-combine-upright
        ruby-merge
        grid
        grid-area
        grid-auto-columns
        grid-auto-flow
        grid-auto-position
        grid-auto-rows
        grid-column
        grid-column-start
        grid-column-end
        grid-row
        grid-row-start
        grid-row-end
        grid-template
        grid-template-areas
        grid-template-rows
        grid-template-columns
        repeat
        ::repeat-index
        ::repeat-item
        minmax
        :unresolved
        var
        counter
        )
      def call
        root_page? ? root : other
        doc
      end

      def root
        # Remove "CSS3 Tutorials" and everything after
        css('#CSS3_Tutorials ~ *', '#CSS3_Tutorials').remove
      end

      def other
        # fix links
        css('a[href]').each do |node|
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if BROKEN_LINKS.include? node['href']
              node['class'] = 'broken'
              node['href'] = '/help#brokenlink'
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
              if node['href'] == 'index'
                node['href'] = 'reference'
              end
            end
          end

        # Remove "|" and "||" links in syntax box (e.g. animation, all, etc.)
        css('.syntaxbox', '.twopartsyntaxbox').css('a').each do |node|
          if node.content == '|' || node.content == '||'
            node.replace node.content
          end
        end

        end
      end
    end
  end
end

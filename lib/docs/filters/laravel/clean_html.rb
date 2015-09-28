module Docs
  class Laravel
    class CleanHtmlFilter < Docs::ReflyFilter

      BROKEN_LINKS = [
      ]
      REPLACED_LINKS = {
      }

      def call
        if subpath.start_with?('/api')
          api
        else
          other
        end
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href'])
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
              node['class'] = 'broken'
            else
              sluglist = slug.split('/')
              nodelist = node['href'].split('/')
              newhref = []
              nodelist.each do |item|
                if item == '..'
                  sluglist.pop
                elsif item != 'api' and item != '5.0'
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

        WrapPreContentWithCode 'hljs actionscript'
        WrapContentWithDivs '_page _laravel'
        doc
      end

      def api
        css('#footer', '.location','#site-nav', '#left-column', '.namespace-breadcrumbs').remove
        # Replace .header with <h1>
        css('.header > h1').each do |node|
          node.parent.before(node).remove
          node.content = 'Laravel' if root_page?
        end

        # wrapping NameSpacelist
        css('.namespace-list').first.name = 'ul' if css('.namespace-list') and css('.namespace-list').first
        nodes = css('.namespace-list > a')
        nodes.wrap("<li></li>")

        # Remove <abbr>
        css('a > abbr').each do |node|
          node.parent['title'] = node['title']
          node.before(node.children).remove
        end

        # Clean up headings
        css('h1 > a', '.content', 'h3 > code', 'h3 strong', 'abbr').each do |node|
          node.before(node.children).remove
        end

        # Remove empty <td>
        css('td').each do |node|
          node.remove if node.content =~ /\A\s+\z/
        end
      end

      def other
        @doc = at_css('#docs-content')

        # Clean up headings
        css('h2 > a').each do |node|
          node.before(node.children).remove
        end

        # Remove code highlighting
        css('pre').each do |node|
          node.content = node.content
        end
      end
    end
  end
end

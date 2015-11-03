module Docs
  class Phaser
    class CleanHtmlFilter < Docs::ReflyFilter
      BROKEN_LINKS = [ 'index']
      REPLACED_LINKS = {}
      def call
        title = at_css('h1')

        if root_page?
          @doc = at_css('#docs-index')

          # Remove first paragraph (old doc details)
          at_css('table').remove

          title.content = 'Phaser'
        else
          @doc = at_css('#docs')

          # Remove useless markup
          css('section > article').each do |node|
            node.parent.replace(node.children)
          end

          css('dt > h4').each do |node|
            dt = node.parent
            dd = dt.next_element
            dt.before(node).remove
            dd.before(dd.children).remove
          end

          css('> div', '> section').each do |node|
            node.before(node.children).remove
          end

          css('h3.subsection-title').each do |node|
            node.name = 'h2'
          end

          css('h4.name').each do |node|
            node.name = 'h3'
          end

          # Remove "Jump to" block
          css('table').each do |table|
            table.remove
          end
        end

        doc.child.before(title)

        # Clean code blocks
        css('pre > code').each do |node|
          node.before(node.children).remove
        end
        fixLinks
        WrapPreContentWithCode 'hljs c'
        WrapContentWithDivs '_page _phaser'
        doc
      end
      def fixLinks
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase
          node['href'] = node['href'].gsub /#\/\/.*/, ''
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']          
          elsif !node['href'].start_with? '#' and !node['href'].start_with? 'http://' and !node['href'].start_with? '#' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'news://' and !node['href'].start_with? 'mailto:'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['title'] = ''
            else
              sluglist = slug.split('/')
              if context[:url].to_s.include? '.html'
                sluglist.pop
              end
              if slug == 'docs/README.md'
                sluglist.pop
              end
              nodelist = sluglist + node['href'].split('/')
              newhref = []
              nodelist.each do |item|
                if item == '..'
                  newhref.pop
                elsif item != '' and !newhref.include? item 
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

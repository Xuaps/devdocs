module Docs
  class Npm
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = [
      ]
      REPLACED_LINKS = {
      }
      def call
        if root_page?
          css('#enterprise', '#policies', '#viewAll').remove
        else
          @doc = doc.at_css('#page')
          css('meta', '.colophon').remove
        end

        css('> section', '.deep-link > a').each do |node|
          node.before(node.children).remove
        end

        css('pre.editor').each do |node|
          node.inner_html = node.inner_html.gsub(/<\/div>(?!\n|\z)/, "</div>\n")
        end

        css('pre').each do |node|
          node.content = node.content
        end
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href'])
          if REPLACED_LINKS[node['href'].downcase]
              node['href'] = REPLACED_LINKS[node['href']]
          elsif !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'mailto:'
            if node.content.strip.include? "\u{00B6}" or node['href'] == '#top'
              node.remove
            elsif node['href'].downcase.include? '/doc/syntax'
              node['class'] = 'broken'
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
              node['class'] = 'broken'
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
        WrapPreContentWithCode 'hljs bash'
        WrapContentWithDivs '_page _nom'
        doc
      end
    end
  end
end
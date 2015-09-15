module Docs
  class Phalcon
    class CleanHtmlFilter < Filter

      BROKEN_LINKS = []
      REPLACED_LINKS = {}
      def call
        @doc = at_css('.body')

        if root_page?
          at_css('h1').content = 'Phalcon'
        end

        css('#what-is-phalcon', '#other-formats').remove

        css('#methods > p > strong, #constants > p > strong').each do |node|
          node.parent.name = 'h3'
          node.parent['id'] = node.content.parameterize
          node.parent['class'] = 'method-signature'
          node.parent.inner_html = node.parent.inner_html.sub(/inherited from .*/, '<small>\0</small>')
        end

        css('.headerlink').each do |node|
          id = node['href'][1..-1]
          node.parent['id'] ||= id
          node.remove
        end

        css('div[class^="highlight-"]').each do |node|
          code = node.at_css('pre').content
          code.remove! %r{\A\s*<\?php\s*} unless code.include?(' ?>')
          node.content = code
          node.name = 'pre'
        end

        css('.section').each do |node|
          node.before(node.children).remove
        end

        css('table[border]').each do |node|
          node.remove_attribute('border')
        end
        fixLinks
        WrapPreContentWithCode 'hljs php'
        WrapContentWithDivs '_page _phalcon'
        doc
      end
      def fixLinks
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase
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

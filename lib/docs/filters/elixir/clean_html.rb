module Docs
  class Elixir
    class CleanHtmlFilter < Docs::ReflyFilter
      REPLACED_LINKS = {}
      BROKEN_LINKS = []
      def call
        at_css('footer', '.view-source').remove

        css('section section.docstring h2').each do |node|
          node.name = 'h4'
        end

        css('h1 .hover-link', '.detail-link').each do |node|
          node.parent['id'] = node['href'].remove('#')
          node.remove
        end

        css('.details-list').each do |list|
          type = list['id'].remove(/s\z/)
          list.css('.detail-header').each do |node|
            node.name = 'h3'
            node['class'] += " #{type}"
          end
        end

        css('.summary h2').each { |node| node.parent.before(node) }
        css('.summary').each { |node| node.name = 'dl' }
        css('.summary-signature').each { |node| node.name = 'dt' }
        css('.summary-synopsis').each { |node| node.name = 'dd' }

        css('section', 'div:not(.type-detail)', 'h2 a').each do |node|
          node.before(node.children).remove
        end

        fixLinks
        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _elixir'
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
              sluglist.pop
              if slug== 'elixir/extra-api-reference'
                sluglist.shift
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

module Docs
  class Haskell
    class CleanHtmlFilter < Docs::ReflyFilter
      BROKEN_LINKS = [
        'containers-0.5.5.1/$',
        'bytestring-0.10.4.0/$',
        'haskell98-2.0.0.3/control-exception-exception',
        'base-4.7.0.0/control-exception-exception',
        'deepseq-1.3.0.2/control-parallel',
        'hoopl-3.10.0.1/fallthrough',
        'bytestring-0.10.4.0/data-bytestring-builder-ascii',
        'template-haskell-2.9.0.0/hello',
        'control-monad-trans-state',
        'base-4.7.0.0/data-generics-basics',
        'base-4.7.0.0/data-generics-instances',
        'base-4.7.0.0/data-array-st',
        'base-4.7.0.0/foreign-foreignptr',
        'base-4.7.0.0/if',
        'bytestring-0.10.4.0/)\''
      ]
      REPLACED_LINKS = {
        'text-prettyprint-hughespj' => 'pretty-1.1.1.1/text-prettyprint-hughespj'
      }
      def call
        root_page? ? root : other
        fixLinks
        WrapPreContentWithCode 'hljs haskell'
        WrapContentWithDivs '_page _haskell'
        doc
      end

      def root
        css('#description', '#module-list').each do |node|
          node.before(node.children).remove
        end
      end

      def other
        css('h1').each do |node|
          node.remove if node.content == 'Documentation'
        end

        css('h1, h2, h3, h4').each do |node|
          node.name = node.name.sub(/\d/) { |i| i.to_i + 1 }
        end

        at_css('#module-header').tap do |node|
          heading = at_css('.caption')
          heading.name = 'h1'
          node.before(heading)
          node.before(node.children).remove
        end

        css('#synopsis').remove

        css('#interface', 'h2 code').each do |node|
          node.before(node.children).remove
        end

        css('a[name]').each do |node|
          node['id'] = node['name']
          node.remove_attribute('name')
          node.name = 'span'
        end

        css('p.caption').each do |node|
          node.name = 'h4'
        end

        css('em').each do |node|
          if node.content.start_with?('O(')
            node.name = 'span'
            node['class'] = 'complexity'
          elsif node.content.start_with?('Since')
            node.name = 'span'
            node['class'] = 'version'
          end
        end
        doc
      end
      def fixLinks
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']          
          elsif !node['href'].start_with? 'http://' and !node['href'].start_with? '#' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'news://' and !node['href'].start_with? 'mailto:'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['title'] = ''
            else
              # puts 'ini: ' + node['href']
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
            # puts 'fin: ' + node['href']
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

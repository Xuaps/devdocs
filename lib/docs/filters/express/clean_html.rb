module Docs
  class Express
    class CleanHtmlFilter < Docs::ReflyFilter
      BROKEN_LINKS = []
      REPLACED_LINKS = {
      #   '4x/starter/installing' => 'starter/installing',
      #   '4x/starter/hello-world' => 'starter/hello-world',
      #   '4x/starter/generator' => 'starter/generator',
      #   '4x/starter/basic-routing' => 'starter/basic-routing',
      #   '4x/starter/static-files' => 'starter/static-files',
      #   '4x/starter/faq' => 'starter/faq',
      #   '4x/guide/routing' => 'guide/routing',
      #   '4x/guide/writing-middleware' => 'guide/writing-middleware',
      #   '4x/guide/using-template-engines' => 'guide/using-template-engines',
      #   '4x/starter/installing' => 'starter/installing',
      #   '4x/guide/debugging' => 'guide/debugging',
      #   '4x/guide/behind-proxies' => 'guide/behind-proxies',
      #   '' => '',
      #   '' => '',
      #   '' => '',
      #   '' => '',
      }
      def call
        css('section', 'div.highlighter-rouge').each do |node|
          node.before(node.children).remove
        end

        css('#navmenu').remove
        # Put id attributes on headings
        css('h2', 'h3', 'h4').each do |node|
          node['id'] = node.content.downcase.tr(' ', '-')
        end

        css('table[border]').each do |node|
          node.remove_attribute 'border'
        end

        # Remove code highlighting
        css('figure.highlight').each do |node|
          node['data-language'] = node.at_css('code[data-lang]')['data-lang']
          node.content = node.content
          node.name = 'pre'
        end

        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase.remove '_(event)'
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']          
          elsif !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'mailto:'
            if node['class'] == 'new' or node['title'] == 'The documentation about this has not yet been written; please consider contributing!'
              node['class'] = 'broken'
              node['title'] = ''
              # node['href'] = context[:domain] + '/help#brokenlink'
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              # node['href'] = context[:domain] + '/help#brokenlink'
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
            if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']
            end
            if node['href'].start_with? '4x/'
              node['href'] = node['href'].tr('x4/','')
            end
          end
        end
        css('pre > code').each do |node|
          node.parent['data-language'] = node['class'][/language-(\w+)/, 1] if node['class']
          node.parent.content = node.parent.content
        end
        WrapPreContentWithCode 'hljs actionscript'
        WrapContentWithDivs '_page _express'
        doc
      end
    end
  end
end

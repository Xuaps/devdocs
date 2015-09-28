module Docs
  class Yii
    class CleanHtmlFilter < Docs::ReflyFilter
      BROKEN_LINKS = [
        'input-file-upload',
        'license.md',
        'guide-tool-debugger',
        'guide-widget-jui',
        'guide-widget-bootstrap'
      ]
      REPLACED_LINKS = {
          'php.net/manual/en/book.pdo.php' => '/php/database_extensions/abstraction_layers/pdo'
      }
      def call
        css('#nav', '.tool-link', '.toggle').remove

        css('.hashlink[name]').each do |node|
          node.parent['id'] = node['name']
          node.remove
        end

        css('.detail-header').each do |node|
          node.name = 'h3'
          node.child.remove while node.child.content.blank?
        end

        css('pre').each do |node|
          node.inner_html = node.inner_html.gsub('<br>', "\n").gsub('&nbsp;', ' ')
          node.content = node.content
        end

        css('div.signature').each do |node|
          node.name = 'pre'
          node.inner_html = node.inner_html.strip
        end

        css('.detail-table th').each do |node|
          node.name = 'td'
        end
        #remove css links
        css('link').each do |node|
          node.remove
        end

        #remove meta
        css('meta').each do |node|
          node.remove
        end
        css('.detail-table td.signature').each do |node|
          node.name = 'th'
        end
        css('a').each do |node|

          if node.inner_html.include? '¶'
              node.remove
          end
        end
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href'])
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            if node['class'] == 'new'
              node['class'] = 'broken'
              # node['href'] = context[:domain] + '/help#brokenlink'
            elsif BROKEN_LINKS.include?node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              # node['href'] = context[:domain] + '/help#brokenlink'
            elsif REPLACED_LINKS[node['href'].remove! '../']
              node['href'] = context[:domain] + REPLACED_LINKS[node['href'].remove! '../']
            end
          end
        end
        
        WrapPreContentWithCode 'hljs signature'
        WrapContentWithDivs '_page _yii'
        doc
      end
    end
  end
end

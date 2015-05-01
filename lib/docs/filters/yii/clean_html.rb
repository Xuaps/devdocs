module Docs
  class Yii
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = [
        'input-file-upload',
        'license.md'
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
              node['href'] = '/help#brokenlink'
            elsif BROKEN_LINKS.include?node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              node['href'] = '/help#brokenlink'
            elsif REPLACED_LINKS[node['href'].remove! '../']
              node['class'] = REPLACED_LINKS[node['href'].remove! '../']
              node['href'] = '/help#brokenlink'
            end
          end
        end
        doc
      end
      def CleanWrongCharacters(href)
          href.gsub('%23', '#').gsub('%28', '(').gsub('%29', ')').gsub('%21', '!').gsub('%7b', '{').gsub('%7e', '~').gsub('%2a', '*').gsub('%2b', '+').gsub('%3d', '=')
      end
    end
  end
end

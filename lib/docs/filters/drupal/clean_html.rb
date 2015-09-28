module Docs
  class Drupal
    class CleanHtmlFilter < Docs::ReflyFilter

      BROKEN_LINKS = []
      REPLACED_LINKS = {}

      def call
        root_page? ? root : other
        fixLinks
        WrapPreContentWithCode 'hljs php'
        WrapContentWithDivs '_page _drupal'
        doc
      end

      def root
        doc.inner_html = ' '
      end

      def other
        css('.element-invisible', '#sidebar-first', '#api-alternatives', '#aside', '.comments', '.view-filters',
            '#api-function-signature tr:not(.active)', '.ctools-collapsible-container', 'img[width="13"]').remove

        at_css('#main').replace(at_css('.content'))
        at_css('#page-heading').replace(at_css('#page-subtitle'))

        css('th.views-field > a', '.content').each do |node|
          node.before(node.children).remove
        end

        css('pre').each do |node|
          node.content = node.content
        end

        # Replaces the signature table from api.drupal.org with a simple pre tag
        css('#api-function-signature').each do |table|
          signature = table.css('.signature').first.at_css('code').inner_html
          table.replace '<pre class="signature">' + signature + '</pre>'
        end
      end

      def fixLinks
        css('a[href]').each do |node|
          # puts 'ini: ' + node['href']
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']     
          elsif !node['href'].start_with? 'http://' and !node['href'].start_with? '#' and !node['href'].start_with? '#' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'news://' and !node['href'].start_with? 'mailto:'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['title'] = ''
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
              node['class'] = 'broken'
            else
              # puts slug
              sluglist = slug.gsub(/%21/, '-').split('/')
              if sluglist.size>1
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
          # puts 'fin: ' + node['href']
        end
      end
    end
  end
end

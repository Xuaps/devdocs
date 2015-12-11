module Docs
  class Dojo
    class CleanHtmlFilter < Docs::ReflyFilter
      BROKEN_LINKS = ['dojo/_base/quickstart/debugging']
      REPLACED_LINKS = {}
      def call
        if root_page?
          doc.inner_html = ' '
          return doc
        end

        css('h1[class]').each do |node|
          node.remove_attribute('class')
        end

        css('.version', '.jsdoc-permalink', '.feedback', '.jsdoc-summary-heading', '.jsdoc-summary-list', '.jsdoc-field.private').remove

        css('.jsdoc-wrapper, .jsdoc-children, .jsdoc-fields, .jsdoc-field, .jsdoc-property-list, .jsdoc-full-summary, .jsdoc-return-description').each do |node|
          node.before(node.children).remove
        end

        css('a[name]').each do |node|
          next unless node.content.blank?
          node.parent['id'] = node['name']
          node.remove
        end

        css('div.returnsInfo', 'div.jsdoc-inheritance').each do |node|
          node.name = 'p'
        end

        css('div.jsdoc-title').each do |node|
          node.name = 'h3'
        end

        css('.returns').each do |node|
          node.inner_html = node.inner_html + ' '
        end

        css('.functionIcon a').each do |node|
          node.replace(node.content)
        end
        fixLinks
        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _dojo'
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

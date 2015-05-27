module Docs
  class Rethinkdb
    class CleanHtmlFilter < Filter

      BROKEN_LINKS = [
        'table_status'
      ]
      REPLACED_LINKS = {

      }

      def call
        if root_page?
          doc.inner_html = '<h1>ReQL command reference</h1>'
          return doc
        end

        css('#api-header').each do |node|
          node.replace(node.at_css('h1'))
        end

        css('.linksbox-container').remove

        css('.highlight').each do |node|
          node.before(node.children).remove
        end

        css('.command-body').each do |node|
          node.name = 'pre'
          node.inner_html = node.inner_html.gsub('</p>', "</p>\n")
        end

        css('pre').each do |node|
          node.content = node.content
        end

        css('h1').each do |node|
          next if node['class'].to_s.include?('title')
          node.name = 'h2'
        end

        # fix links
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).remove '_(event)'
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://'
            # puts 'nodeini: ' + node['href']
            if REPLACED_LINKS[node['href'].remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove! '../']
            elsif BROKEN_LINKS.include?node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              node['href'] = context[:domain] + '/help#brokenlink'
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
            # puts 'nodefin: ' + node['href']
          end
        end

        WrapPreContentWithCode 'hljs nimrod'
        WrapContentWithDivs '_page _rethinkdb'
        doc
      end
    end
  end
end

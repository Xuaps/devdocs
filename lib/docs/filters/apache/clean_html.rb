module Docs
  class Apache
    class CleanHtmlFilter < ReflyFilter

      BROKEN_LINKS = ['mod_h2','mod_proxy_http2']
      REPLACED_LINKS = {}
      def call

        css('.toplang', '#quickview', '.top').remove

        css('> .section', '#preamble', 'a[href*="dict.html"]', 'code var', 'code strong').each do |node|
          node.before(node.children).remove
        end

        css('p > code:first-child:last-child', 'td > code:first-child:last-child').each do |node|
          next if node.previous.try(:content).present? || node.next.try(:content).present?
          node.inner_html = node.inner_html.squish.gsub(/<br(\ \/)?>\s*/, "\n")
          node.content = node.content.strip
          node.name = 'pre' if node.content =~ /\s/
          node.parent.before(node.parent.children).remove if node.parent.name == 'p'
        end

        css('code').each do |node|
          node.inner_html = node.inner_html.squish
        end

        css('.note h3', '.warning h3').each do |node|
          node.before("<p><strong>#{node.inner_html}</strong></p>").remove
        end

        css('h2:not([id]) a[id]:not([href])').each do |node|
          node.parent['id'] = node['id']
          node.before(node.children).remove
        end
        fixLinks
        WrapPreContentWithCode 'hljs apache'
        WrapContentWithDivs '_page _apache'
        doc
      end

      def fixLinks
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase.remove '_(event)'
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']          
          elsif !node['href'].start_with? 'http://' and !node['href'].start_with? '#' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'news://' and !node['href'].start_with? 'mailto:'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['title'] = ''
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
              node['class'] = 'broken'
            else
              sluglist = slug.split('/')
              if context[:url].to_s.end_with? 'html'
                sluglist.pop
              end
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
        end
      end
    end
  end
end

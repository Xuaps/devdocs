module Docs
  class Javase
    class CleanHtmlFilter < Docs::ReflyFilter

      BROKEN_LINKS = []
      REPLACED_LINKS = {
        'allclasses-noframe' => 'http://docs.oracle.com/javase/7/docs/api/allclasses-noframe.html',
        'overview-tree' => 'http://docs.oracle.com/javase/7/docs/api/overview-tree.html',
        'constant-values' => 'http://docs.oracle.com/javase/7/docs/api/constant-values.html',
        'deprecated-list' => 'http://docs.oracle.com/javase/7/docs/api/deprecated-list.html',
        'java/applet/package-summary' => 'http://docs.oracle.com/javase/7/docs/api/java/applet/package-summary.html',
        'index-files/index-1' => 'http://docs.oracle.com/javase/7/docs/api/index-files/index-1.html',
        'synth.dtd' => 'http://docs.oracle.com/javase/7/docs/api/synth.dtd',
        "org/w3c/dom/ls/'http:/www.ietf.org/rfc/rfc2396.txt'" => "http://www.ietf.org/rfc/rfc2396.txt"

      }
      def call
        css('.topNav','.subNav', '.bottomNav', '.legalCopy', '.bottomNav', '.bar', 'noscript', '.subTitle').remove
        fixLinks
        WrapPreContentWithCode 'hljs java'
        WrapContentWithDivs '_page _javase'
        doc
      end

      def fixLinks
        css('a[href]').each do |node|
          # puts 'node ini: ' + node['href']
          node['href'] = CleanWrongCharacters(node['href']).downcase
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']          
          elsif !node['href'].start_with? 'http://' and !node['href'].start_with? '#' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'news://' and !node['href'].start_with? 'mailto:'
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
          node['href'] = REPLACED_LINKS[node['href']] || node['href']
          # puts 'node fin: ' + node['href']
        end
        
      end
    end
  end
end

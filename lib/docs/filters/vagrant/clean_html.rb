module Docs
  class Vagrant
    class CleanHtmlFilter < Docs::ReflyFilter
      BROKEN_LINKS = []
      REPLACED_LINKS = {
        'multi-machine/vagrantfile/index' => 'vagrantfile/index',
        'multi-machine/networking/index' => 'networking/index',
        'multi-machine/networking/private_network' => 'networking/private_network'
      }
      def call
        @doc = at_css('.page-contents .span8')

        css('hr').remove

        css('pre > code').each do |node|
          node.parent['class'] = node['class']
          node.before(node.children).remove
        end
        fixLinks
        WrapPreContentWithCode 'hljs vagrant'
        WrapContentWithDivs '_page _vagrant'
        doc
      end

      def fixLinks
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase
          puts 'ino: ' + node['href']
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']          
          elsif !node['href'].start_with? '#' and !node['href'].start_with? 'http://' and !node['href'].start_with? '#' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'news://' and !node['href'].start_with? 'mailto:'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['title'] = ''
            else
              sluglist = slug.split('/')
              if context[:url].to_s.include? '.html'
                sluglist.pop
              end
              if slug == 'docs/README.md'
                sluglist.pop
              end
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
          puts 'end: ' + node['href']
        end
      end
    end
  end
end

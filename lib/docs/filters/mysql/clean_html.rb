module Docs
  class Mysql
    class CleanHtmlFilter < Docs::ReflyFilter
      BROKEN_LINKS = []
      REPLACED_LINKS = {
        'http:://bugs.mysql.com/bug.php?id=24733' => 'http://bugs.mysql.com/bug.php?id=24733',
        'launchpad.net' => 'http://www.launchpad.net'
      }
      def call
        fixLinks
        WrapPreContentWithCode 'hljs sql'
        WrapContentWithDivs '_page _mysql'
        css('#docs-sidebar-search-box', '.right', '#docs-in-page-nav', '.docs-comment-disclaimer', '.docs-comments-header', '#docs-breadcrumbs', '.docs-sidebar-nav', '.text', '.docs-sidebar-accordian', '.docs-sidebar-header-text').remove
        doc
      end
      def fixLinks
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase
          node['href'] = node['href'].gsub /#\/\/.*/, ''
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
        end
      end
    end
  end
end

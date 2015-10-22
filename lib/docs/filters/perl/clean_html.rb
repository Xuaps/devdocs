module Docs
  class Perl
    class CleanHtmlFilter < Docs::ReflyFilter
      BROKEN_LINKS = ['perlgit', 'deprecate', 'io/socket/ip',
        'io/compress/faq', 'tap/parser/sourcehandler', 'version',
        'cpan/meta/spec', 'cpan/meta', 'tap/parser/sourcehandler',
        'tap/parser/sourcehandler/executable', 'tap/parser/sourcehandler/perl', 'tap/parser/sourcehandler/file',
        'tap/parser/sourcehandler/rawtap', 'tap/parser/sourcehandler/handle', 'encode/supported',
        'pod/simple/subclassing', 'test/tutorial', 'arybase',
        'autodie/exception', 'encode/supported', 'encode/perlio',
        'zipdetails', 'ptargrep', 'unicode/collate/locale',
        'file:line', 'pl2pm', 'encoding/warnings',
        'autodie/hints', 'perlandroid', 'perlsynology',
        'perldoc.tar.gz', 'perldoc-html.tar.gz', 'cpan/meta/yaml'
      ]
      REPLACED_LINKS = {}
      def call
        css('ul').each do |node|
          node.css('a[href]').each do |link|
            if link['href']== '#NAME'
              node.remove
            end
          end
        end
        fixLinks
        WrapPreContentWithCode 'hljs perl'
        WrapContentWithDivs '_page _perl'
        doc
      end

      def fixLinks
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase
          node['href'] = node['href'].gsub /#\/\/.*/, ''
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']          
          elsif !node['href'].start_with? '#' and !node['href'].start_with? 'git://' and !node['href'].start_with? 'http://' and !node['href'].start_with? '#' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'news://' and !node['href'].start_with? 'mailto:'
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

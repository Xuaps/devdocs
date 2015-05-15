module Docs
  class Ruby
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = [
          'i',
          '*rows',
          'rdoc',
          'header',
          'text',
          '123',
          '0-3',
          '0-2',
          '4',
          '3',
          '2',
          '1',
          '0',
          'bqn0',
          'uwm',
          'widgetclassname',
          'ary',
          '_territory',
          'status'
      ]
      REPLACED_LINKS = {
        "www.ruby-lang.org" => "http://www.ruby-lang.org",
        "../drb"            => "libdoc/drb/rdoc/drb",
        "../rexml"          => "libdoc/rexml/rdoc/rexml",
        "task"              => "libdoc/rdoc/rdoc/rdoc/task"
      }
      def call
        css('#actionbar', '#metadata', '.title', '.link-list', 'form', '.info', '.dsq-brlink', '#footer').remove
        css('#wrapper > p').each do |node|
           node.remove if node['style']
        end
        root_page? ? root : other

        doc

      end

      def root
      end

      def other
        css('hr').remove
        # Move id attributes to headings
        css('.method-detail').each do |node|
          next unless heading = node.at_css('.method-heading')
          heading['id'] = node['id']
          node.remove_attribute 'id'
        end

        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href'])
          if REPLACED_LINKS[node['href'].downcase]
              node['href'] = REPLACED_LINKS[node['href']]
          elsif !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://'
            if node.content.strip.include? "\u{00B6}" or node['href'] == '#top'
              node.remove
            elsif node['href'].downcase.include? '/doc/syntax'
              node['class'] = 'broken'
              node['href'] = context[:domain] + '/help#brokenlink'
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
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
          end
        end

      end
    end
  end
end
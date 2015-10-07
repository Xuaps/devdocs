module Docs
  class Cordova
    class CleanHtmlFilter < Docs::ReflyFilter
      REPLACED_LINKS = {}
      BROKEN_LINKS = ['cordova_camera_camera.md', 'guide/platforms/win8/win10-support.md', 'cordova_media_capture_capture.md','cordova_contacts_contacts.md','cordova_geolocation_geolocation.md']
      def call
        if root_page? || slug == 'cordova_events_events.md'
          css('h1, h2').each do |node|
            node.name = node.name.sub(/\d/) { |i| i.to_i + 1 }
          end
          at_css('h2').name = 'h1' if slug == 'cordova_events_events.md'
        end

        if root_page?
          css('li > h3').each do |node|
            node.name = 'div'
          end
        end

        css('hr').remove

        css('a[name]').each do |node|
          node.parent['id'] = node['name']
          node.before(node.children).remove
        end

        css('a[href]').each do |node|
          if BROKEN_LINKS.include? node['href']
            node['class'] = 'broken'
          end
        end

        # Remove code highlighting
        css('pre').each do |node|
          node.content = node.content.remove(/^\ {4,5}/)
        end
        fixLinks
        WrapPreContentWithCode 'hljs javascript'
        WrapContentWithDivs '_page _cordova'
        doc
      end

      def fixLinks
        css('a[href]').each do |node|
          puts 'ini: ' + node['href']
          node['href'] = CleanWrongCharacters(node['href']).downcase
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
          if BROKEN_LINKS.include? node['href'].downcase.remove! '../'
            node['class'] = 'broken'
          end
          node['href'] = REPLACED_LINKS[node['href']] || node['href']
          puts 'fin: ' + node['href']
        end
      end
    end
  end
end

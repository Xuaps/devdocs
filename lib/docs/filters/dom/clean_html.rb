module Docs
  class Dom
    class CleanHtmlFilter < Docs::ReflyFilter

      BROKEN_LINKS = [
          'en-us/docs/web/guide/prefixes',
          'en/dom/table.cells',
          'en/link',
          'en/style',
          'en/chrome',
          'en/firefox_3',
          'en/dom/element',
          'en/dom/element.addeventlistener',
          'en/xpinstall_api_reference/installtrigger_object',
          'en/xpinstall_api_reference/install_object',
          'en/xpinstall_api_reference/file_object',
          'en-us/docs/Web/API/ServiceWorkerContainer',
          'en-us/docs/server-sent_events/using_server-sent_events',
          'video.blendertestbuilds.de/download.blender.org/peach/trailer_1080p.mov',
          'serviceworker_api/en-us/docs/web/api/serviceworkercontainer',
          'service_worker_api/en-us/docs/web/api/serviceworkercontainer',
          'touch_events/web/api/touch_events',
          'geolocation/navigator.requestwakelock()',
          'navigator/removeidleobserver',
          'audiochannels_api/using_the_audiochannels_api',
          'term_hit_test',
          'wake_lock_api',
          'wake_lock_api/keeping_the_geolocation_on_when_the_application_is_invisible',
          'browser_api',
          'permissions_api_(firefox_os)',
          'simple_push_api'
      ]
      REPLACED_LINKS = {
        'eventhandler' => 'https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Event_handlers',
        'float32array' => '#{context[:domain]}/javascript/javascript_reference/standard_built-in_objects/float32array',
        'uint8array'   => '#{context[:domain]}/javascript/javascript_reference/standard_built-in_objects/uint8array',
        'int32array'   => '#{context[:domain]}/javascript/javascript_reference/standard_built-in_objects/int32array',
        'boolean'      => '#{context[:domain]}/javascript/javascript_reference/standard_built-in_objects/boolean',
        'arraybuffer'  => '#{context[:domain]}/javascript/javascript_reference/standard_built-in_objects/arraybuffer',
        'promise'      => '#{context[:domain]}/javascript/javascript_reference/standard_built-in_objects/promise',
        'en/html/element/a' => '#{context[:domain]}/html/html_element_reference/<a>',
        'en/css/background-color' => '#{context[:domain]}/css/background-color',
        'en-us/docs/javascript/reference/global_objects/function/call' => '#{context[:domain]}/javascript/javascript_reference/standard_built-in_objects/function/function.prototype.call',
        'en-us/docs/web/http/headers' => '#{context[:domain]}/http/accept',
        'en/dom/range.compareboundarypoints' => 'range/compareboundarypoints',
        'en/dom/window.screen.top' => 'screen/top',
        'en/dom/window.top' => 'window/top',
        'en-us/docs/web/api/node' => 'node',
        'nfc_api' => 'htmliframeelement',
        'en/dom/document.getelementsbytagname' => 'element/getelementsbytagname'
      }
      def call
        # fix links
        css('a[href]').each do |node|
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'mailto:'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['title'] = ''
              # node['href'] = context[:domain] + '/help#brokenlink'
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              # node['href'] = context[:domain] + '/help#brokenlink'
            elsif REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].downcase.remove! '../']
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
            if BROKEN_LINKS.include? node['href'].downcase.remove! '../'
              node['class'] = 'broken'
            end
          end
        end

        root_page? ? root : other
        WrapPreContentWithCode 'hljs javascript'
        doc
      end

      def root
        #Cleaning content
        css('footer', '.quick-links', 'div.article-meta', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove

      end

      def other
        #Cleaning content
        css('footer', '.quick-links','div.article-meta', '.submenu', 'div.wiki-block', 'nav', '.toc', '#nav-access', '#main-header', '.title').remove

        # Bug fix: HTMLElement.offsetWidth
        css('#offsetContainer .comment').remove

        # Bug fix: CompositionEvent, DataTransfer, etc.
        if (div = at_css('div[style]')) && div['style'].include?('border: solid #ddd 2px')
          div.remove
        end

        # Remove double heading on SVG pages
        if slug.start_with? 'SVG'
          at_css('h2:first-child').try :remove
        end

        # Remove <div> wrapping .overheadIndicator
        css('div > .overheadIndicator:first-child:last-child').each do |node|
          node.parent.replace(node)
        end
      end
    end
  end
end

module Docs
  class DomEvents
    class EntriesFilter < Docs::ReflyEntriesFilter
      TYPE_BY_INFO = {
        'applicationCache' => 'Application Cache',
        'Clipboard'        => 'Clipboard',
        'CSS'              => 'CSS',
        'Drag'             => 'Drag & Drop',
        'Focus'            => 'Focus',
        'Fullscreen'       => 'Fullscreen',
        'HashChange'       => 'History',
        'IndexedDB'        => 'IndexedDB',
        'Keyboard'         => 'Keyboard',
        'edia'             => 'Media',
        'Mouse'            => 'Mouse Event',
        'Offline'          => 'Offline',
        'Orientation'      => 'Device',
        'Sensor'           => 'Device',
        'Page Visibility'  => 'Page Visibility',
        'Pointer'          => 'Mouse Event',
        'PopState'         => 'History',
        'Progress'         => 'Progress',
        'Proximity'        => 'Device',
        'Server Sent'      => 'Server Sent Events',
        'Storage'          => 'Web Storage',
        'Touch'            => 'Touch',
        'Transition'       => 'CSS',
        'PageTransition'   => 'History',
        'WebSocket'        => 'WebSocket',
        'Web Audio'        => 'Web Audio',
        'Web Messaging'    => 'Web Messaging',
        'Wheel'            => 'Mouse',
        'Worker'           => 'Web Workers' }

      FORM_SLUGS = %w(change compositionend compositionstart compositionupdate
        input invalid reset select submit)
      LOAD_SLUGS = %w(abort beforeunload DOMContentLoaded error load
        readystatechange unload)

      APPEND_TYPE = %w(Application\ Cache IndexedDB Progress
        Server\ Sent\ Events WebSocket Web\ Messaging Web\ Workers)

      EXCLUDED_PATH = ['MDN','Web technology for developers', 'JavaScript']
      
      def get_name
        name = super.split.first
        name << " (#{type})" if APPEND_TYPE.include?(type)
        name = 'Event reference' if not name
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name)
        end
        parsed_uri
      end

      def get_parent_uri
        parent_uri = context[:docset_uri]
        xpath('//nav[@class="crumbs"]//a/text()').each do |node|
           link = node.content.strip
           if not EXCLUDED_PATH.include? link
              parent_uri += '/' + self.urilized(link)
           end
        end
        if parent_uri == context[:docset_uri]
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        node = css('p')
        if node[0]
            if node[0].inner_text.downcase.include? ' event '
                'event'
            elsif node[0].inner_text.downcase.include? ' handler '
                return 'handler'
           else
               'others'
            end
        else
            'others'
        end
      end
    end
  end
end

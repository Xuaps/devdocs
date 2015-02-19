module Docs
  class DomEvents
    class EntriesFilter < Docs::EntriesFilter
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

      def get_name
        name = super.split.first
        name << " (#{type})" if APPEND_TYPE.include?(type)
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        parsed_uri = context[:docset_uri] + '/' + path
        parsed_uri
      end

      def get_parent_uri
        subpath = *path.split('/')
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            parent_uri = 'null'
        end
      end

      def get_type
        node = css('p')
        if node[0]
            if node[0].inner_text.downcase.include? ' event '
                'event'
            elsif node[0].inner_text.downcase.include? ' handler '
                return 'handler'
            elsif node[2].inner_text.downcase.include? ' event '
                'event'
           elsif node[2].inner_text.downcase.include? ' handler '
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

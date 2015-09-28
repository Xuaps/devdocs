module Docs
  class Reflux
    class EntriesFilter < Docs::ReflyEntriesFilter
      REPLACE_TYPES = {
        'Content' => 'others',
        'Comparing RefluxJS with Facebook Flux' => 'guide',
        'Examples' => 'others',
        'Extensions and Plugins' => 'utils',
        'Installation' => 'guide',
        'Usage' => 'guide',
        'Advanced usage' => 'guide',
        'Similarities with Flux' => 'guide',
        'Differences with Flux' => 'guide',
        'NPM' => 'platforms',
        'Bower' => 'platforms',
        'CDN' => 'platforms',
        'ES5' => 'platforms',
        'Creating actions' => 'function',
        'Creating data stores' => 'function',
        'Listening to changes in data store' => 'function',
        'React component example' => 'others',
        'Listening to changes in other data stores (aggregate data stores)' => 'function',
        'Switching EventEmitter' => 'function',
        'Switching Promise library' => 'function',
        'Switching Promise factory' => 'function',
        'Switching nextTick' => 'function',
        'Joining parallel listeners with composed listenables' => 'function',
        'Sending initial state with the listenTo function' => 'function',
        'Asynchronous actions' => 'function',
        'Action hooks' => 'function',
        'Reflux.ActionMethods' => 'function',
        'Reflux.StoreMethods' => 'function',
        'Mixins in stores' => 'function',
        'Listening to many actions at once' => 'function',
        'The listenables shorthand' => 'function',
        'Listenables and asynchronous actions' => 'function',
        'Convenience mixin for React' => 'guide',
        'Using Reflux.listenTo' => 'method',
        'Using Reflux.connect' => 'method',
        'Using Reflux.connectFilter' => 'method',
        'Argument tracking' => 'method',
        'Using the listener instance methods' => 'method',
        'Using the static methods' => 'method',
      }
      def get_name
        'Index'
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

      def get_parsed_uri_by_name(name)
        parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        parsed_uri
      end

      def get_parent_uri
       'null'
      end

      def get_type
        'others'
      end

      def additional_entries
        entries = []
        count = 0
        css('h1 a', 'h2 a', 'h3 a', 'h4 a').each do |node|
            count+=1
            name = node.parent.content.strip
            next if name == 'Colophon' or name == 'RefluxJS'
            custom_parsed_uri = get_parsed_uri_by_name(name)
            entries << [name, node['href'].remove('#'), REPLACE_TYPES[name] || 'others', custom_parsed_uri, get_parent_uri, get_docset]
        end
        entries
      end
    end
  end
end

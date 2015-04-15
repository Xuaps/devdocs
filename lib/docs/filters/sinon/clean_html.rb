module Docs
  class Sinon
    class CleanHtmlFilter < Filter
      def call

        css('.section', 'h2 code', 'h3 code').each do |node|
          node.before(node.children).remove
        end

        # Remove code highlighting
        css('pre').each do |node|
          node.content = node.content
        end

        # fixing id in spy api
         css('h3').each do |node|
          if node.content == 'Spy API'
            node['id'] = 'spyprops'
            break
          end
         end
        css('> p:first-child', 'a.api', 'ul.nav').remove
        doc
      end
    end
  end
end

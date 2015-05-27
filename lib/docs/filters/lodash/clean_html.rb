module Docs
  class Lodash
    class CleanHtmlFilter < Filter
      def call
        css('h3 + p', 'hr').remove

        # Set id attributes on <h3> instead of an empty <a>
        css('h3').each do |node|
          node['id'] = node.at_css('a')['id']
        end

        # Remove <code> inside headings
        css('h2', 'h3').each do |node|
          node.content = node.content
        end
        WrapPreContentWithCode 'hljs coffeescript'
        WrapContentWithDivs '_page _lodash'
        doc
      end
    end
  end
end

module Docs
  class Grunt
    class CleanHtmlFilter < Filter
      def call
        @doc = at_css('.hero-unit')

        if root_page?
          at_css('h1').content = 'Grunt'
        end

        css('.end-link').remove

        # Put id attributes on headings
        css('a.anchor').each do |node|
          node.parent['id'] = node['name']
          node.before(node.children).remove
        end
        # Fix wrong anchor
        css('a').each do |node|
          if node['href'].include? '/grunt.log#grunt.log.error'
              node['href'] = '#grunt.log.error-grunt.verbose.error'
          end
        end

        # Remove code highlighting
        css('pre').each do |node|
          node.content = node.content
        end

        doc
      end
    end
  end
end

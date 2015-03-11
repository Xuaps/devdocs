module Docs
  class Php2
    class CleanHtmlFilter < Filter
      def call
        root_page? ? root : other
        doc
      end

      def root
        doc.inner_html = ' '
      end

      def other
        css('.manualnavbar', 'hr').remove
        css('.navbar.navbar-fixed-top').remove
        css('.head').remove
        css('.page-tools').remove
        css('.layout-menu').remove
        css('.navbar-inner.clearfix').remove
        css('#usernotes').remove
        css('#breadcrumbs').remove
        css('#trick').remove
        css('form').remove
        css('footer').remove
        # Remove top-level <div>
        if doc.elements.length == 1
          @doc = doc.first_element_child
        end

        # Put code blocks in <pre> tags
        css('.phpcode > code').each do |node|
          node.name = 'pre'
          node['class'] = 'phpcode  language-php'
        end
      end
    end
  end
end

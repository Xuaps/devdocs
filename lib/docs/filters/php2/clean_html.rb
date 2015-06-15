module Docs
  class Php2
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = [
        'url.imagemagick.usage.color_mods.sigmoidal',
        'url.mongodb.dochub.maxWriteBatchSize',
        'url.mongodb.dochub.maxbsonobjectsize',
        'javascript:;',
        'mongo.configure;',
        'mongo.security;'
      ]
      def call
        root_page? ? root : other
        WrapPreContentWithCode 'hljs php'
        WrapContentWithDivs '_page _php'
        doc
      end

      def root
        doc.inner_html = ' '
      end

      def other
        css('#toTop').remove
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
        #fixing links
        css('a[href]').each do |node|
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'news://'
            if BROKEN_LINKS.include? node['href']
              node['class'] = 'broken'
              # node['href'] = context[:domain] + '/help#brokenlink'
            end
          end
        end
        
        #replace all the classes function for phpfunction to avoid conflict with highlighterjs
        css('.function').each do |node|
          node['class'] = 'phpfunction'
        end
        # Put code blocks in <pre> tags
        css('.phpcode > code').each do |node|
          node.name = 'pre'
          node['class'] = ''
        end
      end
    end
  end
end

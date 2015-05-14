module Docs
  class Angular
    class CleanHtmlFilter < Filter
      REPLACED_LINKS = {
        '' => 'https://code.angularjs.org/1.3.14/docs/guide/'
      }
      BROKEN_LINKS = []

      def call
        root_page? ? root : other

        #Remove ng-* attributes
        css('*').each do |node|
          node.attributes.each_key do |attribute|
            node.remove_attribute(attribute) if attribute.start_with? 'ng-'
          end
        end
        css('a[href]').each do |node|
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']
          end
          node['href'] = node['href'].remove 'api/'
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            puts 'nodeini: ' + node['href']
            if node['href'].start_with? 'guide/'
              node['href'] = 'https://code.angularjs.org/1.3.14/docs/guide/' + node['href'].remove('guide/')
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
              node['class'] = 'broken'
              node['href'] = context[:domain] + '/help#brokenlink'
            end
            puts 'nodefin: ' + node['href']
          end
        end

        css('.improve-docs').remove
        css('.view-source').remove
        doc
      end

      def root
        css('.nav-index-group').each do |node|
          if heading = node.at_css('.nav-index-group-heading')
            heading.name = 'h2'
          end
          node.parent.before(node.children)
        end

        css('.nav-index-section').each do |node|
          node.content = node.content
        end

        css('.toc-close', '.naked-list').remove
      end

      def other
        css('#example', '.example', '#description_source', '#description_demo', '[id$="example"]', 'hr').remove

        css('header').each do |node|
          node.before(node.children).remove
        end

        # Remove root-level <div>
        while div = at_css('h1 + div')
          div.before(div.children)
          div.remove
        end

        css('.api-profile-header-structure > li').each do |node|
          node.inner_html = node.inner_html.remove('- ')
        end

        css('h1').each_with_index do |node, i|
          next if i == 0
          node.name = 'h2'
        end

        # Remove examples
        css('.runnable-example').each do |node|
          node.parent.remove
        end

        # Remove dead links (e.g. ngRepeat)
        css('a.type-hint').each do |node|
          node.name = 'code'
          node.remove_attribute 'href'
        end

        css('pre > code').each do |node|
          node.parent['class'] = node['class']
          node.before(node.children).remove
        end

        # Remove some <code> elements
        css('h1 > code', 'h2 > code', 'h3 > code', 'h4 > code', 'h6 > code').each do |node|
          node.before(node.content).remove
        end

        css('ul.methods', 'ul.properties', 'ul.events').add_class('defs').each do |node|
          node.css('> li > h3').each do |h3|
            next if h3.content.present?
            h3.content = h3.next_element.content
            h3.next_element.remove
          end
        end
      end
    end
  end
end
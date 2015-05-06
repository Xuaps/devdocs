module Docs
  class Grunt
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = [
      ]
      REPLACED_LINKS = {
          'index' => 'getting-started'
      }
      def call
        @doc = at_css('.hero-unit')

        if root_page?
          at_css('h1').content = 'Grunt' if at_css('h1')
        end

        css('.end-link').remove

        # Put id attributes on headings
        css('a.anchor').each do |node|
          node.parent['id'] = node['name']
          node.before(node.children).remove
        end
        # Fix wrong links
        css('a[href]').each do |node|
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            node['href'] = CleanWrongCharacters(node['href']).remove '../'
            if REPLACED_LINKS[node['href'].downcase.remove! '../']
                node['href'] = REPLACED_LINKS[node['href'].remove '../']
            elsif node['href'].include? '/grunt.log#grunt.log.error'
                node['href'] = '#grunt.log.error-grunt.verbose.error'
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
               node['class'] = 'broken'
               node['href'] = context[:domain] + '/help#brokenlink'
            end
          end
        end

        # Remove code highlighting
        css('pre').each do |node|
          node.content = node.content
        end

        doc
      end
      def CleanWrongCharacters(href)
          href.gsub('%23', '#').gsub('%28', '(').gsub('%29', ')').gsub('%21', '!').gsub('%7b', '{').gsub('%7e', '~').gsub('%2a', '*').gsub('%2b', '+').gsub('%3d', '=')
      end
    end
  end
end

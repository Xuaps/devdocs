module Docs
  class Haskell
    class CleanHtmlFilter < Filter
      BROKEN_LINKS = [
        '$',
        'control-exception-exception',
        'control-parallel',
        'fallthrough',
        'system-filepath',
        'data-bytestring-builder-ascii',
        'hello',
        'control-monad-trans-state',
        'foreign-foreignptr',
        'data-generics-basics',
        'data-generics-instances',
        'control-monad-trans-writer',
        'base-4.7.0.0/foreign-foreignptr',
        'if',
        ')\''
      ]
      REPLACED_LINKS = {
        'text-prettyprint-hughespj' => 'pretty-1.1.1.1/text-prettyprint-hughespj'
      }
      def call
        root_page? ? root : other
        doc
      end

      def root
        css('#description', '#module-list').each do |node|
          node.before(node.children).remove
        end
      end

      def other
        css('a[href]').each do |node|
          if !node['href'].start_with? 'http://' and !node['href'].start_with? 'https://'
            node['href'] = CleanWrongCharacters(node['href']).remove '../'
            if REPLACED_LINKS[node['href'].downcase.remove! '../']
                node['href'] = REPLACED_LINKS[node['href'].remove '../']
            elsif node['href'].include? '/grunt.log#grunt.log.error'
                node['href'] = '#grunt.log.error-grunt.verbose.error'
            elsif BROKEN_LINKS.include? node['href'].downcase.remove! '../'
               node['class'] = 'broken'
               # node['href'] = context[:domain] + '/help#brokenlink'
            end
          end
        end
        css('h1').each do |node|
          node.remove if node.content == 'Documentation'
        end

        css('h1, h2, h3, h4').each do |node|
          node.name = node.name.sub(/\d/) { |i| i.to_i + 1 }
        end

        at_css('#module-header').tap do |node|
          heading = at_css('.caption')
          heading.name = 'h1'
          node.before(heading)
          node.before(node.children).remove
        end

        css('#synopsis').remove

        css('#interface', 'h2 code').each do |node|
          node.before(node.children).remove
        end

        css('a[name]').each do |node|
          node['id'] = node['name']
          node.remove_attribute('name')
          node.name = 'span'
        end

        css('p.caption').each do |node|
          node.name = 'h4'
        end

        css('em').each do |node|
          if node.content.start_with?('O(')
            node.name = 'span'
            node['class'] = 'complexity'
          elsif node.content.start_with?('Since')
            node.name = 'span'
            node['class'] = 'version'
          end
        end
        WrapPreContentWithCode 'hljs haskell'
        WrapContentWithDivs '_page _haskell'
        doc
      end
    end
  end
end

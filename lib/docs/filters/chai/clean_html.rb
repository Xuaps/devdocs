module Docs
  class Chai
    class CleanHtmlFilter < Docs::ReflyFilter
      def call
        @doc = at_css('.documentation .rendered')

        if root_page?
          at_css('h1').content = 'Chai Assertion Library'
        end

        css('> article', '.header').each do |node|
          node.before(node.children).remove
        end

        # Fix confictive links
        css('a[href]').each do |node|
          node['href'] = node['href'].remove('../../').remove('../')
          if node['href'] == '../plugins/index'
              node['href'] = 'guide/plugins'
          end
          if node['href'] == 'guide/comparison/index'
              node['href'] = 'guide/styles/index'
          end
          if node['href'] == 'guide'
              node['href'] = 'guide/styles/index'
          end
          if node['href'] == 'helpers/index'
              node['href'] = 'guide/helpers/index'
          end
          if node['href'] == 'plugins/index'
              node['href'] = 'api/plugins/index'
          end
        end
        WrapPreContentWithCode 'hljs lasso'
        WrapContentWithDivs '_page _chai'
        doc
      end
    end
  end
end

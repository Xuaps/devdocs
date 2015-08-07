module Docs
  class Mdn
    class CleanHtmlFilter < Filter
      REMOVE_NODES = [
        '#Summary',          # "Summary" heading
        '.htab',             # "Browser compatibility" tabs
        '.breadcrumbs',      # (e.g. CSS/animation)
        '.Quick_links',      # (e.g. CSS/animation)
        '.todo',
        '.contributor-avatars',
        '.draftHeader']

      def call
        css(*REMOVE_NODES).remove

        css('td.header').each do |node|
          node.name = 'th'
        end

        #remove css links
        css('link').each do |node|
          node.remove
        end

        #remove meta
        css('meta').each do |node|
          node.remove
        end
        css('nobr').each do |node|
          node.before(node.children).remove
        end

        css('h2[style]', 'pre[style]').remove_attr('style')
        WrapContentWithDivs '_page _mdn'
        doc
      end
    end
  end
end

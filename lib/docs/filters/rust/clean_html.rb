module Docs
  class Rust
    class CleanHtmlFilter < Docs::ReflyFilter

      BROKEN_LINKS = [
        'collections/vec/struct.partialveczerosized',
        'collections/vec/struct.partialvecnonzerosized',
        'collections/binary_heap/struct.hole',
        'collections/btree/map/stack/struct.idref',
        'collections/linked_list/struct.rawlink',
        'collections/bit/struct.blockiter',
        'collections/btree/node/struct.node',
        'collections/btree/node/struct.handle',
        'collections/btree/node/struct.abstraversal',
        'collections/str/enum.decompositiontype',
        'collections/str/enum.recompositionstate',
        'collections/slice/enum.direction',
        'collections/linked_list/struct.node',
        'collections/btree/node/struct.movetraversalimpl',
        'collections/btree/node/struct.rawitems',
        'collections/slice/struct.sizedirection',
        'collections/bit/struct.twobitpositions',
        'collections/btree/map/struct.absiter',
        'collections/btree/node/enum.traversalitem',
        'collections/btree/node/struct.elemsandedges',
        'collections/btree/node/trait.traversalimpl',
        'collections/btree/map/trait.traverse'
      ]
      REPLACED_LINKS = {
        'collections/binary_heap/struct.binaryheap/struct.binaryheap' => 'collections/binary_heap/struct.binaryheap',
        'collections/binary_heap/vec/struct.vec' => 'collections/vec/struct.vec',
        'macro.try!' => 'std/macro.try!',
        'std/std/macro.write!' => 'std/macro.write!',
        'std/std/fs/struct.file' => 'std/fs/struct.file',
        'std/std/macro.format_args!' => 'std/macro.format_args!'
      }
      def call


        if slug.start_with?('book')
          book
        elsif slug.start_with?('reference')
          reference
        else
          api
        end

        css('.rusttest', 'hr').remove

        css('.docblock > h1').each { |node| node.name = 'h4' }
        css('h2.section-header').each { |node| node.name = 'h3' }
        css('h1.section-header').each { |node| node.name = 'h2' }

        css('> .impl-items', '> .docblock').each do |node|
          node.before(node.children).remove
        end

        css('h1 > a', 'h2 > a', 'h3 > a', 'h4 > a', 'h5 > a').each do |node|
          node.before(node.children).remove
        end

        css('pre > code').each do |node|
          node.parent['class'] = node['class']
          node.before(node.children).remove
        end

        css('pre').each do |node|
          node.content = node.content
        end
        fixLinks
        WrapPreContentWithCode 'hljs rust'
        WrapContentWithDivs '_page _rust'
        doc
      end
      def fixLinks
        css('a[href]').each do |node|
          node['href'] = CleanWrongCharacters(node['href']).downcase
          if REPLACED_LINKS[node['href'].downcase.remove! '../']
              node['href'] = REPLACED_LINKS[node['href'].remove '../']          
          elsif !node['href'].start_with? '#' and !node['href'].start_with? 'http://' and !node['href'].start_with? '#' and !node['href'].start_with? 'https://' and !node['href'].start_with? 'ftp://' and !node['href'].start_with? 'irc://' and !node['href'].start_with? 'news://' and !node['href'].start_with? 'mailto:'
            if node['class'] == 'new'
              node['class'] = 'broken'
              node['title'] = ''
            else
              sluglist = slug.remove('struct.binaryheap/').split('/')
              if context[:url].to_s.include? '.html'
                sluglist.pop
              end
              if slug == 'book/index'
                sluglist.pop
              end
              nodelist = sluglist + node['href'].split('/')
              newhref = []
              nodelist.each do |item|
                if item == '..'
                  newhref.pop
                elsif item != ''
                  newhref << item
                end
              end
              node['href'] = newhref.join('/')
            end
          end
          if BROKEN_LINKS.include? node['href'].downcase.remove! '../'
            node['class'] = 'broken'
          end
          node['href'] = REPLACED_LINKS[node['href']] || node['href']
        end
        
      end

      def book
        @doc = at_css('#page')
      end

      def reference
        css('#versioninfo').remove
      end

      def api
        @doc = at_css('#main')

        css('.toggle-wrapper').remove

        css('h1.fqn').each do |node|
          node.content = node.at_css('.in-band').content
        end

        css('.stability .stab').each do |node|
          node.name = 'span'
          node.content = node.content
        end
      end
    end
  end
end

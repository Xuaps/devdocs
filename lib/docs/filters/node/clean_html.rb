module Docs
  class Node
    class CleanHtmlFilter < Filter
      REPLACED_ANCHOR = {
        '#http_response_end_data_encoding'    => '#http_response_end_data_encoding_callback',
        '#http_response_write_chunk_encoding' => '#http_response_write_chunk_encoding_callback',
        '#http_response_writehead_statuscode_reasonphrase_headers' => '#http_response_writehead_statuscode_statusmessage_headers'
      }
      def call
        # Remove "#" links
        css('.mark').each do |node|
          node.parent.parent['id'] = node['id']
          node.parent.remove
        end

        css('pre[class*="api_stability"]').each do |node|
          node.name = 'div'
        end

        css('pre').each do |node|
          node.content = node.content
        end

        #fix anchors
        css('a').each do |node|
          if REPLACED_ANCHOR.has_key? node['href']
              node['href'] = REPLACED_ANCHOR[node['href']]
          end
        end
        doc = WrapContentWithDivs('_page _node',@doc)
        doc
      end
    end
  end
end

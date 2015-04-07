module Docs
  class Underscore
    class CleanHtmlFilter < Filter
      def call
        # Remove Links, Changelog
        css('#links ~ *', '#links').remove

        css('tt').each do |node|
          code = Nokogiri::XML::Node.new "code", doc
          code.content = node.content
          node.content = ''
          node.name = 'pre'
          node << code
        end

        css('code').each do |node|
          code = Nokogiri::XML::Node.new "code", doc
          code.content = node.content
          node.content = ''
          node.name = 'pre'
          node << code
        end

        css('pre').each do |node|
          code = Nokogiri::XML::Node.new "code", doc
          code.content = node.content
          node.content = ''
          node << code
        end

        doc
      end
    end
  end
end

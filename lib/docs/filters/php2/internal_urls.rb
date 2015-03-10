module Docs
  class Php2
    class InternalUrlsFilter < Filter
      def call
        if subpath.start_with?('book.') || subpath.start_with?('class.') || subpath.start_with?('ref.') ||  subpath.start_with?('function.')
        result[:internal_urls] = internal_urls
        end
        doc
      end

      def internal_urls
        css('.book a', '.chunklist a', '.set a', '.chapter a', '.article a', '.refentry a', '.sect1 a', '.reference a', 'ul li a').inject [] do |urls, link|
          urls << link['href'] if link.next.try(:text?) && link['href'].exclude?('ref.pdo-')
          #puts 'link: ' + link['href']
          urls
        end
      end
    end
  end
end

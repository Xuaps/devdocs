module Docs
  class Php
    class FixUrlsFilter < Docs::ReflyFilter
      def call
        html.gsub! File.join(Php.base_url, Php.root_path), Php.base_url
        html.gsub! %r{http://www\.php\.net/manual/en/([^"']+?)\.html}, 'http://www.php.net/manual/en/\1.php'
        html
      end
    end
  end
end

module Docs
  class Django
    class FixUrlsFilter < Docs::ReflyFilter
      def call
        html.gsub! %r{#{Regexp.escape(Django.base_url)}([^"']+?)\.html}, "#{Django.base_url}\\1/"
        html
      end
    end
  end
end

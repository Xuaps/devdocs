module Docs
  class Jquery
    class CleanUrlsFilter < Docs::ReflyFilter
      def call
        html.gsub! 'local.api.jquery', 'api.jquery'
        html
      end
    end
  end
end

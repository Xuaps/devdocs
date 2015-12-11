module Docs
  class Dojo
    class CleanUrlsFilter < Docs::ReflyFilter
      def call
        html.remove! '?xhr=true'
        html
      end
    end
  end
end

module Docs
  class Angular
    class CleanUrlsFilter < Docs::ReflyFilter
      def call
        #html.gsub! "angularjs.org/#{Angular.version}/docs/partials/api", "angularjs.org/#{Angular.version}/docs/api"
        #html.gsub! %r{angularjs.org/#{Angular.version}/docs/api/(.+?)\.html}, "angularjs.org/#{Angular.version}/docs/api/\1"
        html
      end
    end
  end
end
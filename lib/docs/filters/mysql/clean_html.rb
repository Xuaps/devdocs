module Docs
  class Mysql
    class CleanHtmlFilter < Docs::ReflyFilter
      def call
        WrapPreContentWithCode 'hljs sql'
        WrapContentWithDivs '_page _mysql'
        css('#docheader', 'div[style]', '#comments', '#docnav', 'small').remove
        doc
      end
    end
  end
end

module Docs
  class ReflyFilter < Docs::Filter

    def docset_uri
      context[:docset_uri]
    end

    def CleanWrongCharacters(href)
        href.gsub('%23', '#').gsub('%40', '@').gsub('%28', '(').gsub('%29', ')').gsub('%21', '!').gsub('%7b', '{').gsub('%7e', '~').gsub('%2a', '*').gsub('%2b', '+').gsub('%3d', '=').gsub('%3A', ':')
    end

    def remove_html_tags(content)
      re = /<("[^"]*"|'[^']*'|[^'">])*>/
      return content.gsub!(re, '')
    end

    def WrapPreContentWithCode(classname)
      css('pre').each do |node|
        node['class'] = classname
        if !node.children[0] || node.children[0].name != 'code'
            codetag = Nokogiri::XML::Node.new "code", @doc
            codetag.children = node.children
            node.children = codetag
        end
      end
    end

    def WrapContentWithDivs(classname)
        divremovable = Nokogiri::XML::Node.new "div", @doc
        divcontainer = Nokogiri::XML::Node.new "div", @doc
        divcontainer['class'] = classname
        divcontainer.children = @doc
        divremovable.children = divcontainer
        @doc = divremovable
    end
  end
end

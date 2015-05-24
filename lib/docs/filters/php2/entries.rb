module Docs
  class Php2
    class EntriesFilter < Docs::EntriesFilter
      EXCLUDED_PATH = ['PHP Manual', 'Language Reference', 'Function Reference','Other Basic Extensions', 'Table of Contents']

      def get_name

        return 'IntlException' if slug == 'class.intlexception'
        name = css('> .sect1 > .title','.refname', 'h1', 'h2', 'h4','.section > table > caption > strong').first.content
        name.remove! 'The '
        name.sub! ' class', ' (class)'
        name.sub! ' interface', ' (interface)'
        name
      end

      def get_alias
          node = xpath('//li[@class="current"]/a/text()')
          if node.nil? or get_name.include? '::' or path.start_with?('ref.pdo-sqlsrv.php')
              _alias = name
          else
              _alias = node.to_s
          end
          _alias
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_alias)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_alias)
        end
        parsed_uri
      end

      def get_parent_uri
        parent_uri = context[:docset_uri]
        xpath('//*[@id="breadcrumbs-inner"]//li/a/text()').each do |node|
           link = node.content.strip
           if not EXCLUDED_PATH.include? link
               parent_uri += '/' + self.urilized(link)
           end
        end
        if parent_uri == context[:docset_uri]
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        if slug.include? 'types'
            'type'
        elsif slug.include? 'interface'
            'interface'
        elsif slug.include? 'variables'
            'variable'
        elsif slug.include? 'language.constants'
            'constant'
        elsif slug.include? 'appendices'
            'interface'
        elsif slug.include? 'migration'
            'guide'
        elsif slug.include? 'faq'
            'guide'
        elsif slug.include? ' install'
            'guide'
        elsif slug.include? 'basic'
            'guide'
        elsif slug.include? 'language.expressions.'
            'guide'
        elsif slug.include? 'language.operators.'
            'guide'
        elsif slug.include? 'control-structures.'
            'function'
        elsif slug.include? 'funcs.'
            'function'
        elsif slug.include? 'cairocontext.'
            'function'
        elsif slug.include? 'function.'
            'function'
        elsif slug.include? 'language.oop5'
            'class'
        elsif slug.include? 'class.'
            'class'
        elsif slug.include? 'language.namespaces.'
            'namespace'
        elsif slug.include? 'language.exceptions.'
            'class'
        elsif slug.include? 'language.references.'
            'guide'
        elsif slug.include? 'operators.'
            'variable'
        elsif slug.include? 'context.'
            'guide'
        elsif slug.include? '::.'
            'method'
        elsif slug.include? 'wrappers.'
            'class'
        else
            'others'
        end
      end

      def include_default_entry?
        doc.at_css('.reference', '.refentry', '.sect1', 'section', '.set', '.legalnotice', '.book', '.chapter', '.appendix', '.preface', '.section', '.article','.part')
      end
    end
  end
end

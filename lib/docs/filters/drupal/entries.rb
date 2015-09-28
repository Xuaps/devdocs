module Docs
  class Drupal
    class EntriesFilter < Docs::ReflyEntriesFilter

      def get_name
        name = at_css('#page-subtitle').content
        name.remove! %r{(abstract|public|static|protected|final|function|class)\s+}
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name)
        end
        parsed_uri
      end

      def get_parent_uri
          parent_uri = 'null'
      end

      def get_type
          if at_css('#page-subtitle').content.include? '::'
            type = 'method'
          elsif at_css('#page-subtitle').content.include? 'class'
            type = 'class'
          elsif at_css('#page-subtitle').content.include? 'taxonomy'
            type = 'function'
          elsif at_css('#page-subtitle').content.include? 'taxonomy'
            type = 'function'
          elsif at_css('#page-subtitle').content.include? 'form' or at_css('#page-subtitle').content.include? 'theme' or at_css('#page-subtitle').content.include? 'Field'
            type = 'view'
          elsif at_css('#page-subtitle').content.include? 'function'
            type = 'function'
          else
            type = css('.breadcrumb > a')[1].content.strip
            if type.include? '.inc' or type.include? 'node'
              type = 'guide'
            elsif type.include? 'module'
              type = 'module'
            end
            type = type.split('.').first
          end
          type
      end

      def include_default_entry?
        !initial_page?
      end
    end
  end
end

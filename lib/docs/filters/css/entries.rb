module Docs
  class Css
    class EntriesFilter < Docs::ReflyEntriesFilter
      DATA_TYPE_SLUGS = %w(angle basic-shape color_value counter frequency
        gradient image integer length number percentage position_value ratio
        resolution shape string time timing-function uri user-ident)

      FUNCTION_SLUGS = %w(attr reference calc cross-fade cubic-bezier cycle element
        linear-gradient radial-gradient repeating-linear-gradient
        repeating-radial-gradient var)

      PSEUDO_ELEMENT_SLUGS = %w(::after ::before ::first-letter ::first-line
        ::selection)

      VALUE_SLUGS = %w(auto inherit initial none normal unset)

      ADDITIONAL_ENTRIES = {
        'shape' => [
          %w(rect() Syntax function /css/-lshape-r/syntax /css/-lshape-r CSS)],
        'uri' => [
          %w(The-url-functional-notation The_url()_functional_notation function /css/uri/the-url-functional-notation null CSS) ],
        'timing-function' => [
          %w(cubic-bezier() The_cubic-bezier()_class_of_timing-functions function /css/-ltiming-function-r/cubic-bezier()  /css/-ltiming-function-r CSS),
          %w(steps() The_steps()_class_of_timing-functions function /css/-ltiming-function-r/steps() /css/-ltiming-function-r CSS),
          %w(linear linear value /css/-ltiming-function-r/linear /css/-ltiming-function-r CSS),
          %w(ease ease value /css/-ltiming-function-r/ease /css/-ltiming-function-r CSS),
          %w(ease-in ease-in value /css/-ltiming-function-r/ease-in /css/-ltiming-function-r CSS),
          %w(ease-in-out ease-in-out value /css/-ltiming-function-r/ease-in-out /css/-ltiming-function-r CSS),
          %w(ease-out ease-out value /css/-ltiming-function-r/ease-out /css/-ltiming-function-r CSS),
          %w(step-start step-start value /css/-ltiming-function-r/step-start /css/-ltiming-function-r CSS),
          %w(step-end step-end value /css/-ltiming-function-r/step-end /css/-ltiming-function-r CSS) ],
        'color_value' => [
          %w(transparent transparent_keyword value /css/-lcolor-r/transparent /css/-lcolor-r CSS),
          %w(currentColor currentColor_keyword value /css/-lcolor-r/currentColor /css/-lcolor-r CSS),
          %w(rgb() rgb() function /css/-lcolor-r/rgb() /css/-lcolor-r CSS),
          %w(hsl() hsl() function /css/-lcolor-r/hsl() /css/-lcolor-r CSS),
          %w(rgba() rgba() function /css/-lcolor-r/rgba() /css/-lcolor-r CSS),
          %w(hsla() hsla() function /css/-lcolor-r/hsla() /css/-lcolor-r CSS)]}
      EXCLUDED_PATH = ['MDN','Web technology for developers', 'CSS']
      def get_name
        if css('h1')
            name = css('h1').first.content
        else
            name = 'Index'
        end
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
        parent_uri = context[:docset_uri]
        css('.crumb a').each do |node|
          link = node.content
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
        if slug.include? 'selectors'
          'selector'
        elsif slug.start_with? ':'
          PSEUDO_ELEMENT_SLUGS.include?(slug) ? 'element' : 'class'
        elsif slug.start_with? '@'
          'selector'
        elsif DATA_TYPE_SLUGS.include?(slug)
          'type'
        elsif FUNCTION_SLUGS.include?(slug)
          'function'
        elsif VALUE_SLUGS.include?(slug)
          'value'
        else
          'property'
        end
      end

      def include_default_entry?
        return (slug != '' and !slug.start_with? '%')
      end

      def additional_entries
        ADDITIONAL_ENTRIES[slug] || []
      end
    end
  end
end

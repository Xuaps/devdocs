module Docs
  class Css
    class EntriesFilter < Docs::EntriesFilter
      DATA_TYPE_SLUGS = %w(angle basic-shape color_value counter frequency
        gradient image integer length number percentage position_value ratio
        resolution shape string time timing-function uri user-ident)

      FUNCTION_SLUGS = %w(attr calc cross-fade cubic-bezier cycle element
        linear-gradient radial-gradient repeating-linear-gradient
        repeating-radial-gradient var)

      PSEUDO_ELEMENT_SLUGS = %w(::after ::before ::first-letter ::first-line
        ::selection)

      VALUE_SLUGS = %w(auto inherit initial none normal unset)

      ADDITIONAL_ENTRIES = {
        'shape' => [
          %w(rect() Syntax function /css/_shape_/syntax /css/_shape_ CSS)],
        'uri' => [
          %w(The-url-functional-notation The_url()_functional_notation function /css/uri/the-url-functional-notation null CSS) ],
        'timing-function' => [
          %w(cubic-bezier() The_cubic-bezier()_class_of_timing-functions function /css/_timing-function_/cubic-bezier()  /css/_timing-function_ CSS),
          %w(steps() The_steps()_class_of_timing-functions function /css/_timing-function_/steps() /css/_timing-function_ CSS),
          %w(linear linear value /css/_timing-function_/linear /css/_timing-function_ CSS),
          %w(ease ease value /css/_timing-function_/ease /css/_timing-function_ CSS),
          %w(ease-in ease-in value /css/_timing-function_/ease-in /css/_timing-function_ CSS),
          %w(ease-in-out ease-in-out value /css/_timing-function_/ease-in-out /css/_timing-function_ CSS),
          %w(ease-out ease-out value /css/_timing-function_/ease-out /css/_timing-function_ CSS),
          %w(step-start step-start value /css/_timing-function_/step-start /css/_timing-function_ CSS),
          %w(step-end step-end value /css/_timing-function_/step-end /css/_timing-function_ CSS) ],
        'color_value' => [
          %w(transparent transparent_keyword value /css/_color_/transparent /css/_color_ CSS),
          %w(currentColor currentColor_keyword value /css/_color_/currentColor /css/_color_ CSS),
          %w(rgb() rgb() function /css/_color_/rgb() /css/_color_ CSS),
          %w(hsl() hsl() function /css/_color_/hsl() /css/_color_ CSS),
          %w(rgba() rgba() function /css/_color_/rgba() /css/_color_ CSS),
          %w(hsla() hsla() function /css/_color_/hsla() /css/_color_ CSS) ],
        'transform-function' => [
          %w(matrix() matrix() function /css/transform-function/matrix() /css/transform-function CSS),
          %w(matrix3d() matrix3d() function /css/transform-function/matrix3d() /css/transform-function CSS),
          %w(rotate() rotate() function /css/transform-function/rotate() /css/transform-function CSS),
          %w(rotate3d() rotate3d() function /css/transform-function/rotate3d() /css/transform-function CSS),
          %w(rotateX() rotateX() function /css/transform-function/rotateX() /css/transform-function CSS),
          %w(rotateY() rotateY() function /css/transform-function/rotateY() /css/transform-function CSS),
          %w(rotateZ() rotateZ() function /css/transform-function/rotateZ() /css/transform-function CSS),
          %w(scale() scale() function /css/transform-function/scale() /css/transform-function CSS),
          %w(scale3d() scale3d() function /css/transform-function/scale3d() /css/transform-function CSS),
          %w(scaleX() scaleX() function /css/transform-function/scaleX() /css/transform-function CSS),
          %w(scaleY() scaleY() function /css/transform-function/scaleY() /css/transform-function CSS),
          %w(scaleZ() scaleZ() function /css/transform-function/scaleZ() /css/transform-function CSS),
          %w(skew() skew() function /css/transform-function/skew /css/transform-function CSS),
          %w(skewX() skewX() function /css/transform-function/skewX() /css/transform-function CSS),
          %w(skewY() skewY() function /css/transform-function/skewY() /css/transform-function CSS),
          %w(translate() translate() function /css/transform-function/translate() /css/transform-function CSS),
          %w(translate3d() translate3d() function /css/transform-function/translate3d() /css/transform-function CSS),
          %w(translateX() translateX() function /css/transform-function/translateX() /css/transform-function CSS),
          %w(translateY() translateY() function /css/transform-function/translateY() /css/transform-function CSS),
          %w(translateZ() translateZ() function /css/transform-function/translateZ() /css/transform-function CSS) ]}

      def get_name
        case type
        when 'type' then "<#{super.remove ' value'}>"
        when 'function'  then "#{super}()"
        else super
        end
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
        subpath = *path.split('/')
        if subpath.length > 1
            parent_uri = (context[:docset_uri]+ '/' + subpath[0,subpath.size-1].join('/')).downcase
        else
            parent_uri = 'null'
        end
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

      def additional_entries
        ADDITIONAL_ENTRIES[slug] || []
      end
    end
  end
end

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
          %w(rect() Syntax function /css/shape/syntax Syntax /css/shape CSS)],
        'uri' => [
          %w(The-url-functional-notation The_url()_functional_notation function /css/uri/the-url-functional-notation The_url()_functional_notation /css/uri CSS) ],
        'timing-function' => [
          %w(cubic-bezier() The_cubic-bezier()_class_of_timing-functions function /css/timing-function/cubic-bezier() The_cubic-bezier()_class_of_timing-functions /css/timing-function CSS),
          %w(steps() The_steps()_class_of_timing-functions function /css/timing-function/steps() The_steps()_class_of_timing-functions /css/timing-function CSS),
          %w(linear linear value /css/timing-function/linear linear /css/timing-function CSS),
          %w(ease ease value /css/timing-function/ease ease /css/timing-function CSS),
          %w(ease-in ease-in value /css/timing-function/ease-in ease-in /css/timing-function CSS),
          %w(ease-in-out ease-in-out value /css/timing-function/ease-in-out ease-in-out /css/timing-function CSS),
          %w(ease-out ease-out value /css/timing-function/ease-out ease-out /css/timing-function CSS),
          %w(step-start step-start value /css/timing-function/step-start step-start /css/timing-function CSS),
          %w(step-end step-end value /css/timing-function/step-end step-end /css/timing-function CSS) ],
        'color_value' => [
          %w(transparent transparent_keyword value color_value/transparent transparent_keyword /css/color_value CSS),
          %w(currentColor currentColor_keyword value color_value/currentColor currentColor_keyword /css/color_value CSS),
          %w(rgb() rgb() function /css/color_value/rgb() rgb() /css/color_value CSS),
          %w(hsl() hsl() function /css/color_value/hsl() hsl() /css/color_value CSS),
          %w(rgba() rgba() function /css/color_value/rgba() rgba() /css/color_value CSS),
          %w(hsla() hsla() function /css/color_value/hsla() hsla() /css/color_value CSS) ],
        'transform-function' => [
          %w(matrix() matrix() function /css/transform-function/matrix() matrix() /css/transform-function CSS),
          %w(matrix3d() matrix3d() function /css/transform-function/matrix3d() matrix3d() /css/transform-function CSS),
          %w(rotate() rotate() function /css/transform-function/rotate() rotate() /css/transform-function CSS),
          %w(rotate3d() rotate3d() function /css/transform-function/rotate3d() rotate3d() /css/transform-function CSS),
          %w(rotateX() rotateX() function /css/transform-function/rotateX() rotateX() /css/transform-function CSS),
          %w(rotateY() rotateY() function /css/transform-function/rotateY() rotateY() /css/transform-function CSS),
          %w(rotateZ() rotateZ() function /css/transform-function/rotateZ() rotateZ() /css/transform-function CSS),
          %w(scale() scale() function /css/transform-function/scale() scale() /css/transform-function CSS),
          %w(scale3d() scale3d() function /css/transform-function/scale3d() scale3d() /css/transform-function CSS),
          %w(scaleX() scaleX() function /css/transform-function/scaleX() scaleX() /css/transform-function CSS),
          %w(scaleY() scaleY() function /css/transform-function/scaleY() scaleY() /css/transform-function CSS),
          %w(scaleZ() scaleZ() function /css/transform-function/scaleZ() scaleZ() /css/transform-function CSS),
          %w(skew() skew() function /css/transform-function/skew skew() /css/transform-function CSS),
          %w(skewX() skewX() function /css/transform-function/skewX() skewX() /css/transform-function CSS),
          %w(skewY() skewY() function /css/transform-function/skewY() skewY() /css/transform-function CSS),
          %w(translate() translate() function /css/transform-function/translate() translate() /css/transform-function CSS),
          %w(translate3d() translate3d() function /css/transform-function/translate3d() translate3d() /css/transform-function CSS),
          %w(translateX() translateX() function /css/transform-function/translateX() translateX() /css/transform-function CSS),
          %w(translateY() translateY() function /css/transform-function/translateY() translateY() /css/transform-function CSS),
          %w(translateZ() translateZ() function /css/transform-function/translateZ() translateZ() /css/transform-function CSS) ]}

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
        parsed_uri = context[:docset_uri] + '/' + path
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

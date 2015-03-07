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
          %w(rect() Syntax function /css/shape#Syntax null CSS)],
        'uri' => [
          %w(url() The_url()_functional_notation function /css/uri#The_url()_functional_notation null CSS) ],
        'timing-function' => [
          %w(cubic-bezier() The_cubic-bezier()_class_of_timing-functions function /css/timing-function#The_cubic-bezier()_class_of_timing-functions null CSS),
          %w(steps() The_steps()_class_of_timing-functions function /css/timing-function#The_steps()_class_of_timing-functions null CSS),
          %w(linear linear value /css/timing-function#linear null CSS),
          %w(ease ease value /css/timing-function#ease null CSS),
          %w(ease-in ease-in value /css/timing-function#ease-in null CSS),
          %w(ease-in-out ease-in-out value /css/timing-function#ease-in-out null CSS),
          %w(ease-out ease-out value /css/timing-function#ease-out null CSS),
          %w(step-start step-start value /css/timing-function#step-start null CSS),
          %w(step-end step-end value /css/timing-function#step-end null CSS) ],
        'color_value' => [
          %w(transparent transparent_keyword value color_value#transparent null CSS),
          %w(currentColor currentColor_keyword value color_value#currentColor null CSS),
          %w(rgb() rgb() function color_value#rgb() null CSS),
          %w(hsl() hsl() function color_value#hsl() null CSS),
          %w(rgba() rgba() function color_value#rgba() null CSS),
          %w(hsla() hsla() function color_value#hsla() null CSS) ],
        'transform-function' => [
          %w(matrix() matrix() function transform-function#matrix()  null CSS),
          %w(matrix3d() matrix3d() function transform-function#matrix3d()  null CSS),
          %w(rotate() rotate() function transform-function#rotate() null CSS),
          %w(rotate3d() rotate3d() function transform-function#rotate3d()  null CSS),
          %w(rotateX() rotateX() function transform-function#rotateX()  null CSS),
          %w(rotateY() rotateY() function transform-function#rotateY()  null CSS),
          %w(rotateZ() rotateZ() function transform-function#rotateZ()  null CSS),
          %w(scale() scale() function transform-function#scale()  null CSS),
          %w(scale3d() scale3d() function transform-function#scale3d()  null CSS),
          %w(scaleX() scaleX() function transform-function#scaleX()  null CSS),
          %w(scaleY() scaleY() function transform-function#scaleY()  null CSS),
          %w(scaleZ() scaleZ() function transform-function#scaleZ()  null CSS),
          %w(skew() skew() function transform-function#skew()  null CSS),
          %w(skewX() skewX() function transform-function#skewX()  null CSS),
          %w(skewY() skewY() function transform-function#skewY()  null CSS),
          %w(translate() translate() function transform-function#translate()  null CSS),
          %w(translate3d() translate3d() function transform-function#translate3d()  null CSS),
          %w(translateX() translateX() function transform-function#translateX()  null CSS),
          %w(translateY() translateY() function transform-function#translateY()  null CSS),
          %w(translateZ() translateZ() function transform-function#translateZ()  null CSS) ]}

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

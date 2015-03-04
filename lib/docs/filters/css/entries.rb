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
          %w(rect() Syntax Functions /css/shape#Syntax null CSS)],
        'uri' => [
          %w(url() The_url()_functional_notation Functions /css/uri#The_url()_functional_notation null CSS) ],
        'timing-function' => [
          %w(cubic-bezier() The_cubic-bezier()_class_of_timing-functions Functions /css/timing-function#The_cubic-bezier()_class_of_timing-functions null CSS),
          %w(steps() The_steps()_class_of_timing-functions Functions, /css/timing-function#The_steps()_class_of_timing-functions null CSS),
          %w(linear linear Values /css/timing-function#linear null CSS),
          %w(ease ease Values /css/timing-function#ease null CSS),
          %w(ease-in ease-in Values /css/timing-function#ease-in null CSS),
          %w(ease-in-out ease-in-out Values /css/timing-function#ease-in-out null CSS),
          %w(ease-out ease-out Values /css/timing-function#ease-out null CSS),
          %w(step-start step-start Values /css/timing-function#step-start null CSS),
          %w(step-end step-end Values /css/timing-function#step-end null CSS) ],
        'color_value' => [
          %w(transparent transparent_keyword Values color_value#transparent null CSS),
          %w(currentColor currentColor_keyword Values color_value#currentColor null CSS),
          %w(rgb() rgb() Functions color_value#rgb() null CSS),
          %w(hsl() hsl() Functions color_value#hsl() null CSS),
          %w(rgba() rgba() Functions color_value#rgba() null CSS),
          %w(hsla() hsla() Functions color_value#hsla() null CSS) ],
        'transform-function' => [
          %w(matrix() matrix() Functions transform-function#matrix()  null CSS),
          %w(matrix3d() matrix3d() Functions transform-function#matrix3d()  null CSS),
          %w(rotate() rotate() Functions transform-function#rotate() null CSS),
          %w(rotate3d() rotate3d() Functions transform-function#rotate3d()  null CSS),
          %w(rotateX() rotateX() Functions transform-function#rotateX()  null CSS),
          %w(rotateY() rotateY() Functions transform-function#rotateY()  null CSS),
          %w(rotateZ() rotateZ() Functions transform-function#rotateZ()  null CSS),
          %w(scale() scale() Functions transform-function#scale()  null CSS),
          %w(scale3d() scale3d() Functions transform-function#scale3d()  null CSS),
          %w(scaleX() scaleX() Functions transform-function#scaleX()  null CSS),
          %w(scaleY() scaleY() Functions transform-function#scaleY()  null CSS),
          %w(scaleZ() scaleZ() Functions transform-function#scaleZ()  null CSS),
          %w(skew() skew() Functions transform-function#skew()  null CSS),
          %w(skewX() skewX() Functions transform-function#skewX()  null CSS),
          %w(skewY() skewY() Functions transform-function#skewY()  null CSS),
          %w(translate() translate() Functions transform-function#translate()  null CSS),
          %w(translate3d() translate3d() Functions transform-function#translate3d()  null CSS),
          %w(translateX() translateX() Functions transform-function#translateX()  null CSS),
          %w(translateY() translateY() Functions transform-function#translateY()  null CSS),
          %w(translateZ() translateZ() Functions transform-function#translateZ()  null CSS) ]}

      def get_name
        case type
        when 'Data Types' then "<#{super.remove ' value'}>"
        when 'Functions'  then "#{super}()"
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
        if slug.end_with? 'selectors'
          'Selectors'
        elsif slug.start_with? ':'
          PSEUDO_ELEMENT_SLUGS.include?(slug) ? 'Pseudo-elements' : 'Pseudo-classes'
        elsif slug.start_with? '@'
          'At-rules'
        elsif DATA_TYPE_SLUGS.include?(slug)
          'Data Types'
        elsif FUNCTION_SLUGS.include?(slug)
          'Functions'
        elsif VALUE_SLUGS.include?(slug)
          'Values'
        else
          'Properties'
        end
      end

      def additional_entries
        ADDITIONAL_ENTRIES[slug] || []
      end
    end
  end
end

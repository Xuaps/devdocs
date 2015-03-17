module Docs
  class Svg
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        name = super
        name.remove!('Element.').try(:downcase!)
        name.remove!('Attribute.').try(:downcase!)
        name.remove!('Tutorial.')
        name.gsub!('_', '')

        if name.in?(%w(Element Attribute Content\ type))
          "#{name}s"
        else
          name
        end
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(name)
        end
        parsed_uri
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
        if slug.start_with?('Element')
          'element'
        elsif slug.start_with?('Attribute')
          'attribute'
        elsif slug.start_with?('Tutorial')
          'tutorial'
        elsif slug == 'Content_type'
          'type'
        else
          'others'
        end
      end

      def additional_entries
        return [] unless slug == 'Content_type'
        entries = []

        css('h2[id]').each do |node|
          dl = node.next_element
          next unless dl.name == 'dl'
          name = dl.at_css('dt').content.remove(/[<>]/)
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, node['id'], get_type.downcase, custom_parsed_uri, get_parent_uri, get_docset]
        end
        entries
      end
    end
  end
end

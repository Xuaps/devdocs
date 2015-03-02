module Docs
  class Yii
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        name = at_css('h1').content.strip
        name.remove! %r{\A.*?(Class|Trait|Interface)\s*}
        name.remove!('yii\\')
        name
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
        if slug.include?('guide')
          'Guides'
        else
          components = name.split('\\')
          type = components.first
          type << "\\#{components.second}" if (type == 'db' && components.second.in?(%w(cubrid mssql mysql oci pgsql sqlite))) ||
                                              (type == 'web' && components.second.in?(%w(Request Response)))
          type = 'yii' if type == 'BaseYii' || type == 'Yii'
          type
        end
      end

      def additional_entries
        css('.detail-header').each_with_object [] do |node, entries|
          name = node.child.content.strip
          name.prepend "#{self.name} "
          entries << [name, node['id'], type, get_parsed_uri.tr('\\', '-') + '.' + node['id'], get_parent_uri, get_docset]
        end
      end
    end
  end
end

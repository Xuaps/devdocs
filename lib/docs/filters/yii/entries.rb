module Docs
  class Yii
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        name = at_css('h1').content.strip
        name.remove! %r{\A.*?(Class|Trait|Interface)\s*}
        name.remove!('yii\\')
        name.remove! "\u{00B6}"
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
        if slug.include?'guide'
          'guide'
        elsif slug.include? 'web' or slug.include? 'rest' or slug.include? 'mailer'
          'network'
        elsif slug.include? 'mongodb' or slug.include? 'mutex' or slug.include? 'db' or slug.include? 'i18n' or slug.include? 'i18n' or slug.include? 'data'
          'data'
        elsif slug.include? 'baseyii' or slug.include? 'gii' or slug.include? 'base' or slug.include? 'base'
          'core'
        elsif slug.include? 'twig' or slug.include? 'smarty' or slug.include? 'widgets' or slug.include? 'bootstrap' or slug.include? 'jui'
          'view'
        elsif slug.include? 'rbac' or slug.include? 'authclient' or slug.include? 'capcha'
          'security'
        elsif slug.include? 'codeception' or slug.include? 'test' or slug.include? 'debug' or slug.include? 'log'
          'test'
        else
          'others'
        end
      end

      def additional_entries
        css('.detail-header').each_with_object [] do |node, entries|
          name = node.child.content
          name.remove! "\u{00B6}"
          name.strip!
          name.prepend "#{self.name} "
          custom_parsed_uri = get_parsed_uri + '#' + node['id']
          entries << [name, node['id'], type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

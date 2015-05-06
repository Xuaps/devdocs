module Docs
  class Redis
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        name = slug.gsub('-', ' ')
        name = 'Index' if name == ''
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
        if at_css('aside > ul:last-child a')
          case at_css('aside > ul:last-child a').content.strip
            when 'DEL'          then 'function'
            when 'APPEND'       then 'function'
            when 'HDEL'         then 'function'
            when 'BLPOP'        then 'function'
            when 'SADD'         then 'function'
            when 'ZADD'         then 'function'
            when 'PSUBSCRIBE'   then 'function'
            when 'DISCARD'      then 'function'
            when 'EVAL'         then 'function'
            when 'AUTH'         then 'network'
            when 'BGREWRITEAOF' then 'network'
            when 'PFADD'        then 'others'
            else 'others'
          end
        else
          'others'
        end
      end
    end
  end
end

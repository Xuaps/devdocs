module Docs
  class Redis
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        slug.gsub('-', ' ')
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
        case at_css('aside > ul:last-child a').content.strip
        when 'DEL'          then 'Keys'
        when 'APPEND'       then 'Strings'
        when 'HDEL'         then 'Hashes'
        when 'BLPOP'        then 'Lists'
        when 'SADD'         then 'Sets'
        when 'ZADD'         then 'Sorted Sets'
        when 'PSUBSCRIBE'   then 'Pub/Sub'
        when 'DISCARD'      then 'Transactions'
        when 'EVAL'         then 'Scripting'
        when 'AUTH'         then 'Connection'
        when 'BGREWRITEAOF' then 'Server'
        when 'PFADD'        then 'HyperLogLog'
        else 'others'
        end
      end
    end
  end
end

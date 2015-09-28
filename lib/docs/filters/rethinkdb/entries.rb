module Docs
  class Rethinkdb
    class EntriesFilter < Docs::ReflyEntriesFilter
      def get_name
        at_css('.title').content.remove('ReQL command:').split(', ').first
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
          context[:docset_uri] + '/' + self.urilized(name)
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
        link = at_css('a[href^="https://github.com/rethinkdb/docs/blob/master/api/javascript/"]')
        dir = link['href'][/javascript\/([^\/]+)/, 1]
        dir.titleize.gsub('Rql', 'ReQL').gsub('And', 'and')
      end

      def additional_entries
        at_css('.title').content.split(', ')[1..-1].map do |name|
          custom_parsed_uri = get_parsed_uri_by_name(name)
          [name,'', get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end

      # def get_type
      #   link = at_css('a[href^="https://github.com/rethinkdb/docs/blob/master/api/javascript/"]')
      #   dir = link['href'][/javascript\/([^\/]+)/, 1]
      #   dir = dir.titleize.gsub('Rql', 'ReQL').gsub('And', 'and')
      #   if dir.include? 'Joins' or dir.include? 'Data' or  dir.include? 'Tables' or dir.include? 'Databases'
      #       'databse'
      #   elsif dir.include? 'Manipulation' or  dir.include? 'Math' or dir.include? 'String' or dir.include? 'Dates'
      #       'function'
      #   else
      #       'others'
      #   end
      # end
    end
  end
end

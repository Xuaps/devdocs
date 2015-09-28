module Docs
  class Nginx
    class EntriesFilter < Docs::ReflyEntriesFilter
      ADDITIONAL_ENTRIES = {
        'stream' => [
          %w(Stream nil others /nginx/stream null Nginx)],
        'core' => [
        %w(Core nil others /nginx/core null Nginx)],
        'module' => [
        %w(Module nil others /nginx/module null Nginx)],
        'guide' => [
        %w(Guide nil others /nginx/guide null Nginx)]}

      def get_name
        name = at_css('h1').content.strip
        name.sub! %r{\AModule ngx}, 'ngx'
        name
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
          context[:docset_uri] + '/' + self.urilized(name)
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
        context[:docset_uri]+ '/' + self.urilized(get_type)
      end

      def get_type
        if slug.include? 'stream'
          'stream'
        elsif slug.include? 'core'
          'core'
        elsif slug.include? 'module'
          'module'
        else
          'guide'
        end
      end

      def additional_entries
        return ADDITIONAL_ENTRIES['stream'] if slug == 'control'
        return ADDITIONAL_ENTRIES['core'] if slug == 'dirindex'
        return ADDITIONAL_ENTRIES['module'] if slug == 'varindex'
        return ADDITIONAL_ENTRIES['guide'] if slug == 'beginners_guide'
        css('h1 + ul a').each_with_object [] do |node, entries|
          name = node.content.strip
          next if name =~ /\A[A-Z]/
          id = node['href'].remove('#')
          next if id.blank?
          custom_parsed_uri = get_parsed_uri_by_name(name)
          entries << [name, id, get_type, custom_parsed_uri, get_parent_uri, get_docset]
        end
      end
    end
  end
end

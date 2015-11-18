module Docs
  class Vagrant
    class EntriesFilter < Docs::ReflyEntriesFilter

      REPLACE_TYPES = {
        'Provisioning' => 'platform',
        'Push' => 'plugin',
        'Installation' => 'guide',
        'Providers' => 'platform',
        'Synced Folders' => 'network',
        'VMware' => 'platform',
        'VirtualBox' => 'platform',
        'Hyper-V' => 'platform',
        'Networking' => 'network',
        'Boxes' => 'module',
        'Docker' => 'platform',
        'Command-Line Interface' => 'guide',
        'Vagrantfile' => 'guide',
        'Vagrant Share' => 'network',
        'Getting Started' => 'guide',
        'Overview' => 'guide',
        'Other' => 'others',
        'Multi-Machine' => 'platform',
      }
      def get_name
        if slug.start_with?('push/')
          name = at_css('h2').try(:content)
        elsif slug.start_with?('cli/')
          name = at_css('h1 + p > strong > code').try(:content).try(:[], /\s*vagrant\s+[\w\-]+/)
        end

        name || at_css('h1').content
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(get_name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(get_name)
        end
        parsed_uri
      end

      def get_parsed_uri_by_name(name)
        if get_parent_uri == 'null'
            parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
        else
            parsed_uri = get_parent_uri + '/' + self.urilized(name)
        end
        parsed_uri
      end

      def get_parent_uri
        parent_uri = context[:docset_uri]
        xpath('//nav[@class="crumbs"]//a/text()').each do |node|
           link = node.content.strip
           if not EXCLUDED_PATH.include? link
              parent_uri += '/' + self.urilized(link)
           end
        end
        if parent_uri == context[:docset_uri]
            parent_uri = 'null'
        end
        parent_uri
      end

      def get_type
        REPLACE_TYPES[at_css('.sidebar-nav li.current').content] || 'others'
      end

      def additional_entries
        case at_css('h1 + p > strong > code').try(:content)
        when /config\./
          h2 = nil
          css('.page-contents .span8 > *').each_with_object [] do |node, entries|
            if node.name == 'h2'
              h2 = node.content
            elsif h2 == 'Available Settings' && (code = node.at_css('code')) && (name = code.content) && name.start_with?('config.')
              id = code.parent['id'] = name.parameterize
              custom_parsed_uri = get_parsed_uri_by_name(name)
              entries << [name, id, 'configuration', custom_parsed_uri, get_parent_uri, get_docset]
            end
          end
        else
          []
        end
      end
    end
  end
end

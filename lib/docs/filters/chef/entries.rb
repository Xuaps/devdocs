module Docs
  class Chef
    class EntriesFilter < Docs::ReflyEntriesFilter
      WORKFLOW_SLUG_LIST = [
        'berkshelf',
        'rubocop',
        'chef_vault',
        'chefspec',
        'foodcritic',
        'knife',
        'provisioning',
        'policy',
        'windows',
        'debug',
        'cookbook_versions',
        'roles',
        'data_bags',
        'environments',
        'kitchen',
        'config_yml_kitchen',
        'plugin_kitchen_vagrant'
      ]
      COOKBOOK_SLUG_LIST = [
        'attributes',
        'cookbooks',
        'definitions',
        'files',
        'libraries',
        'recipes',
        'resource',
        'templates',
        'cookbook_repo',
        'ruby'
      ]
      GUIDE_SLUG_LIST =[
        'workstation',
        'chef_repo',
        'nodes',
        'server_components',
        'chef_client',
        'analytics',
        'delivery',
        'auth',
        'auth_authentication',
        'auth_authorization',
        'run_lists',
        'containers',
        'chef_search',
        'chef_private_keys',
        'chef_system_requirements',
        'install_dk',
        'install_bootstrap',
        'install_windows',
        'install_omnibus',
        'junos',
        'manage',
        'install_push_jobs',
        'install_reporting',
        'install_analytics',
        'uninstall',
        'install_server',
        'install_server_ha_aws',
        'install_server_ha_drbd',
        'install_server_tiered',
        'aws_marketplace',
        'dsl_recipe',
        'dsl_custom_resource',
        'dsl_handler',
        'authorization',
        'chef_shell'
      ]
      COMPONENTS_SLUG_LIST = [
        'ohai',
        'push_jobs',
        'server_replication',
        'reporting',
        'supermarket'
      ]
      SERVER_SLUG_LIST = [
        'server_backup_restore',
        'server_data',
        'server_firewalls_and_ports',
        'server_high_availability',
        'server_ldap',
        'server_logs',
        'server_monitor',
        'server_orgs',
        'server_security',
        'server_services',
        'server_tuning',
        'server_users',
        'upgrade_analytics',
        'upgrade_client',
        'upgrade_server',
        'server_manage_clients',
        'server_manage_cookbooks',
        'server_manage_data_bags',
        'server_manage_environments',
        'server_manage_nodes',
        'server_manage_reports',
        'server_manage_roles',
        'analytics_monitor',
        'install_server_pre',
        'runbook',
        'chef_server'
      ]
      PLUGIN_SLUG_LIST = [
        'custom_resources',
        'dsl_recipe',
        'handlers',
        'plugin_community',
        'ohai_custom'
      ]
      def get_name
        node = css('h1')
        node.css('.headerlink').remove
        name = node.first.content
        name
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
        parsed_uri = get_parsed_uri + '/' + self.urilized(name)
        parsed_uri
      end

      def get_parent_uri
       'null'
      end

      def get_type
        if WORKFLOW_SLUG_LIST.include? slug
          type = 'workflow'
        elsif COOKBOOK_SLUG_LIST.include? slug
          type = 'guide'
        elsif GUIDE_SLUG_LIST.include? slug or slug.include? 'solo'
          type ='guide'
        elsif COMPONENTS_SLUG_LIST.include? slug
          type ='components'
        elsif SERVER_SLUG_LIST.include? slug
          type ='server'
        elsif PLUGIN_SLUG_LIST.include? slug or slug.include? 'knife' or slug.include? 'webui'
          type ='components'
        elsif slug.include? 'api'
          type ='api'
        elsif slug.include? 'resource_'
          type ='resource'
        elsif slug.include? 'ctl'
          type ='command'
        elsif slug.include? 'config'
          type ='configuration'
        else
          type = 'others'
        end
          
        type
      end

      def additional_entries
        entries = []
        css('div.section[id] h3').each do |node|
          node.css('.headerlink').remove
          id = node.parent['id']
          name = get_name + ' ' + node.content
          custom_parsed_uri = get_parsed_uri_by_name(name)
          custom_parent_uri = get_parsed_uri
          entries << [name, id, get_type || 'others', custom_parsed_uri, custom_parent_uri, get_docset]
        end
        entries
      end
    end
  end
end

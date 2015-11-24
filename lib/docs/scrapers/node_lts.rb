module Docs
  class NodeLts < Node
    self.name = 'Node.js (LTS)'
    self.slug = 'node_lts'
    self.type = 'node'
    self.version = '4.2.1'
    self.base_url = 'https://nodejs.org/dist/v4.2.1/docs/api/'

    options[:root_title] = 'NodeJS LTS'
    options[:docset_uri] = '/nodejs_lts'
  end
end

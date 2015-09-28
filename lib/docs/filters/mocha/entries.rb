module Docs
  class Mocha
    class EntriesFilter < Docs::ReflyEntriesFilter
      ENTRIES = {
        'asynchronous-code' => ['done()'],
        'hooks' => ['before()', 'after()', 'beforeEach()', 'afterEach()', 'suiteSetup()', 'suiteTeardown()', 'setup()', 'teardown()'],
        'exclusive-tests' => ['only()'],
        'inclusive-tests' => ['skip()'],
        'usage' => ['mocha'],
        'bdd-interface' => ['describe()', 'context()', 'it()'],
        'tdd-interface' => ['suite()', 'test()'],
        'exports-interface' => ['exports'],
        'qunit-interface' => ['QUnit'],
        'require-interface' => ['require'],
        'browser-setup' => ['setup()'],
        'mocha.opts' => ['mocha.opts'],
        'suite-specific-timeouts' => ['timeout()']
      }
      def get_name
        'Index'
      end

      def get_docset
        docset = context[:root_title]
        docset
      end

      def get_parsed_uri_by_name(name)
        parsed_uri = context[:docset_uri] + '/' + self.urilized(name)
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

      def get_type
          'others'
      end
      def get_parent_uri
          parent_uri = 'null'
          parent_uri
      end

      def additional_entries
        ENTRIES.each_with_object [] do |(id, names), entries|
          type = case id
            when 'hooks' then 'function'
            when /interface/ then 'interface'
            else 'others' end

          names.each do |name|
            custom_parsed_uri = get_parsed_uri_by_name(name)
            custom_parent_uri = '/mocha/index'
            entries << [name, id, type, custom_parsed_uri, custom_parent_uri, get_docset]
          end
        end
      end
    end
  end
end

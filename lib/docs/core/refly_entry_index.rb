require 'yajl/json_gem'

module Docs
  class ReflyEntryIndex
    def add(entry)
      if entry.is_a? Array
        entry.each(&method(:add))
      else
        add_entry(entry)
      end
    end
  end
end

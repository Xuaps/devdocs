module Docs
  class EntriesFilter < Filter
    def call
      result[:entries] = entries
      doc
    end

    def entries
      entries = []
      entries << default_entry if root_page? || include_default_entry?
      entries.concat(additional_entries)
      build_entries(entries)
    end

    def include_default_entry?
      true
    end

    def default_entry
      [name]
    end

    def additional_entries
      []
    end

    def name
      return @name if defined? @name
      @name = root_page? ? nil : get_name
    end

   def docset
      return @docset if defined? @docset
      @docset = root_page? ? nil : get_docset
    end

    def parents_chain
      return @parents_chain if defined? @parents_chain
      @parents_chain = root_page? ? nil : get_parents_chain
    end

    def get_name
      slug.to_s.gsub('_', ' ').gsub('/', '.').squish!
    end

    def type
      return @type if defined? @type
      @type = root_page? ? nil : get_type
    end

    def get_type
      nil
    end

    def path
      result[:path]
    end

    def build_entries(entries)
      entries.map do |attributes|
        build_entry(*attributes)
      end
    end

    def build_entry(name, frag = nil, type = nil, parents_chain = nil, docset = nil)
      type ||= self.type
      docset ||= self.docset
      parents_chain = self.parents_chain
      Entry.new name, frag ? "#{path}##{frag}" : path, type, parents_chain, docset
    end
  end
end

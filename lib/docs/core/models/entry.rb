module Docs
  class Entry
    attr_accessor :name, :type, :path, :parents_chain, :docset

    def initialize(name = nil, path = nil, type = nil, parents_chain = nil, docset = nil)
      self.name = name
      self.path = path
      self.type = type
      self.parents_chain = parents_chain
      self.docset = docset
    end

    def ==(other)
      other.name == name && other.path == path && other.type == type
    end

    def <=>(other)
      name.to_s.casecmp(other.name.to_s)
    end

    def docset=(value)
      @docset = value.try :strip
    end

    def parents_chain=(value)
      @parents_chain = value.try :strip
    end

    def name=(value)
      @name = value.try :strip
    end

    def type=(value)
      @type = value.try :strip
    end

    def root?
      path == 'index'
    end

    def as_json
      { name: name, path: path, type: type, parents_chain: parents_chain, docset: docset }
    end
  end
end

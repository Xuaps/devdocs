module Docs
  class Entry
    attr_accessor :name, :type, :path, :parsed_uri, :parent_uri, :docset

    def initialize(name = nil, path = nil, type = nil, parsed_uri = nil, parent_uri = nil, docset = nil)
      self.name = name
      self.path = path
      self.type = type
      self.parsed_uri = parsed_uri
      self.parent_uri = parent_uri
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

    def parsed_uri=(value)
      @parsed_uri = value.try :strip
    end

    def parent_uri=(value)
      @parent_uri = value.try :strip
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
      { name: name, path: path, type: type, parsed_uri: parsed_uri, parent_uri: parent_uri, docset: docset }
    end
  end
end

module Docs
  class ReflyEntry < Docs::Entry
    attr_accessor :name, :type, :path, :parsed_uri,:anchor, :parent_uri, :docset, :source_url
    def initialize(name = nil, path = nil, type = nil, parsed_uri = nil, anchor = nil, parent_uri = nil, docset = nil, source_url = nil)
      self.name = name
      self.path = path
      self.type = type
      self.parsed_uri = parsed_uri
      self.anchor = anchor
      self.parent_uri = parent_uri
      self.docset = docset
      self.source_url = source_url
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

    def anchor=(value)
      @anchor = value.try :strip
    end

    def parent_uri=(value)
      @parent_uri = value.try :strip
    end

    def source_url=(value)
      @source_url = value.try :strip
    end

    def name=(value)
      @name = value.try :strip
    end

    def type=(value)
      @type = value.try :strip
    end

    def root?
      if anchor!=''
          return false
      else
          return path == 'index'
      end
    end

    def as_json
      { name: name, path: path, source_url: source_url, type: type, parsed_uri: parsed_uri, anchor: anchor, parent_uri: parent_uri, docset: docset }
    end
  end
end

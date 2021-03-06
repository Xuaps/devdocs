module Docs
  class ReflyEntriesFilter < Docs::EntriesFilter
    def call
      result[:entries] = entries
      doc
    end

    def entries
      entries = []
      entries << default_entry if include_default_entry?
      entries.concat(additional_entries)
      build_entries(entries)
    end

    def include_default_entry?
      true
    end

    def default_entry
      [get_name, nil, get_type, get_parsed_uri, get_parent_uri, get_docset]
    end
      # transform string into a valid uri
    def urilized(str)
        str.strip.downcase.gsub('\\', '-').gsub('[', '.').gsub('>', '-r').gsub('<', '-l').gsub(']', '.').tr('“', '').tr('^', '.-.').tr('?', '-').tr('#', '-').tr('”','').tr(' ','_').tr('//','').tr("'", ".").tr(",", ".").tr('/','-').tr('"', '').tr('(', '').tr(')', '').tr('::', '-').tr(':','').tr('?','').tr('*','x').gsub(/\u200B/){''}
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

    def parsed_uri
      return @parsed_uri if defined? @parsed_uri
      @parsed_uri = root_page? ? nil : get_parsed_uri
    end

    def anchor
      return @anchor if defined? @anchor
      @anchor = root_page? ? nil : get_anchor
    end

    def parent_uri
      return @parent_uri if defined? @parent_uri
      @parent_uri = root_page? ? nil : get_parent_uri
    end

    def get_name
      slug.to_s.gsub('_', ' ').gsub('/', '.').squish!
    end

    def get_path
      path
    end

    def get_docset
      context[:root_title]
    end
    
    def get_parsed_uri
        context[:docset_uri] + '/' + self.urilized(name)
    end

    def get_anchor
      'null'
    end

    def get_source_url
      context[:url].to_s
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

    def build_entry(name, frag = nil, type = nil, parsed_uri = nil, parent_uri = nil, docset = nil)
      anchor = frag
      anchor = "" if frag == nil or frag == 'nil'
      type ||= self.type
      docset ||= self.docset
      parsed_uri ||= self.parsed_uri
      parent_uri ||= self.parent_uri
      source_url = self.get_source_url
      ReflyEntry.new name, path, type, parsed_uri, anchor, parent_uri, docset, source_url
    end
  end
end

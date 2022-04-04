require "uri"
require "./utils"

module Wayback
  struct Query
    @limit : Int32?
    @offset : Int32?
    @from : Time?
    @to : Time?

    def self.url(url : String) : Query
      new(url: url)
    end

    def initialize(*, @url : String)
      @limit = nil
      @offset = nil
      @from = nil
      @to = nil
      @filters = URI::Params.new
    end

    def latest(count : Int32) : Query
      @limit = count.abs * -1
      self
    end

    def earliest(count : Int32) : Query
      @limit = count.abs
      self
    end

    def limit(count : Int32) : Query
      @limit = count
      self
    end

    def offset(count : Int32) : Query
      @offset = count
      self
    end

    def from(time : Time) : Query
      @from = time
      self
    end

    def to(time : Time) : Query
      @to = time
      self
    end

    def status_code(code : Int32 | Regex) : Query
      add_filter("statuscode", code)
    end

    def status_code_not(code : Int32 | Regex) : Query
      add_not_filter("statuscode", code)
    end

    def mimetype(mime : String | Regex) : Query
      add_filter("mimetype", mime)
    end

    def mimetype_not(mime : String | Regex) : Query
      add_not_filter("mimetype", mime)
    end

    def digest(digest : String | Regex) : Query
      add_filter("digest", digest)
    end

    def digest_not(digest : String | Regex) : Query
      add_not_filter("digest", digest)
    end

    def clear : Query
      @from = nil
      @to = nil
      @filters.each do |field, _pattern|
        @filters.delete_all(field)
      end
      self
    end

    def to_query_string : String
      URI::Params.build do |params|
        params.add("url", @url)
        @filters.each do |field, pattern|
          params.add("filter", "#{field}:#{pattern}")
        end
        if from = @from
          params.add("from", Utils.to_timestamp(from))
        end
        if to = @to
          params.add("to", Utils.to_timestamp(to))
        end
        if offset = @offset
          params.add("offset", offset.to_s)
        end
        if limit = @limit
          params.add("limit", limit.to_s)
          params.add("fastLatest", "true") if limit.negative?
        end
      end
    end

    private def add_not_filter(filter : String, value) : Query
      not_filter = "!#{filter}"
      add_filter(not_filter, value)
    end

    private def add_filter(filter : String, value) : Query
      @filters.add(filter, parse_value(value))
      self
    end

    def parse_value(value) : String
      case value
      when Regex
        value.inspect
      when String
        value
      else
        value.to_s
      end
    end
  end
end

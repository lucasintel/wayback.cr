require "uri"
require "./utils"

module Wayback
  struct Query
    ID          = "urlkey"
    TIMESTAMP   = "timestamp"
    URL         = "original"
    MIMETYPE    = "mimetype"
    STATUS_CODE = "statuscode"
    DIGEST      = "digest"

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
      @collapse = {} of String => Int32?
      @with_aggregate_count = false
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
      add_filter(STATUS_CODE, code)
    end

    def status_code_not(code : Int32 | Regex) : Query
      add_not_filter(STATUS_CODE, code)
    end

    def mimetype(mime : String | Regex) : Query
      add_filter(MIMETYPE, mime)
    end

    def mimetype_not(mime : String | Regex) : Query
      add_not_filter(MIMETYPE, mime)
    end

    def digest(digest : String | Regex) : Query
      add_filter(DIGEST, digest)
    end

    def digest_not(digest : String | Regex) : Query
      add_not_filter(DIGEST, digest)
    end

    def group_by_id(*, position : Int32? = nil) : Query
      collapse(ID, position)
    end

    def group_by_decade : Query
      collapse(TIMESTAMP, 2)
    end

    def group_by_year : Query
      collapse(TIMESTAMP, 4)
    end

    def group_by_month : Query
      collapse(TIMESTAMP, 6)
    end

    def group_by_day : Query
      collapse(TIMESTAMP, 8)
    end

    def group_by_hour : Query
      collapse(TIMESTAMP, 10)
    end

    def group_by_minute : Query
      collapse(TIMESTAMP, 12)
    end

    def group_by_second : Query
      collapse(TIMESTAMP, 14)
    end

    def group_by_url(*, position : Int32? = nil) : Query
      collapse(URL, position)
    end

    def group_by_mimetype(*, position : Int32? = nil) : Query
      collapse(MIMETYPE, position)
    end

    def group_by_status_code(*, position : Int32? = nil) : Query
      collapse(STATUS_CODE, position)
    end

    def group_by_digest(*, position : Int32? = nil) : Query
      collapse(DIGEST, position)
    end

    def with_aggregate_count : Query
      @with_aggregate_count = true
      self
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
        @collapse.each do |field, precision|
          value = precision ? "#{field}:#{precision}" : field
          params.add("collapse", value)
        end
        params.add("showGroupCount", "true") if @with_aggregate_count
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

    private def add_not_filter(field : String, value) : Query
      not_field = "!#{field}"
      add_filter(not_field, value)
    end

    private def add_filter(field : String, value) : Query
      @filters.add(field, parse_value(value))
      self
    end

    private def collapse(field : String, precision : Int32? = nil) : Query
      @collapse[field] = precision
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

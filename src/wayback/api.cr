require "./protocol/snapshots_parser"
require "./query"
require "./snapshot"
require "./version"
require "http/client"

module Wayback
  class Api
    API_HOST        = "web.archive.org"
    USER_AGENT      = "wayback.cr/#{VERSION} (+https://github.com/kandayo/wayback.cr)"
    CONNECT_TIMEOUT = 30.seconds
    READ_TIMEOUT    = 30.seconds

    def initialize(
      *,
      api_host : String = API_HOST,
      user_agent : String = USER_AGENT,
      connect_timeout : Time::Span = CONNECT_TIMEOUT,
      read_timeout : Time::Span = CONNECT_TIMEOUT
    )
      @transport = HTTP::Client.new(api_host, tls: true)
      @transport.connect_timeout = connect_timeout
      @transport.read_timeout = connect_timeout
      @transport.before_request do |request|
        request.headers["Accept-Encoding"] = "gzip, deflate"
        request.headers["User-Agent"] = user_agent
      end
    end

    def perform(query : Query) : Array(Snapshot)
      @transport.get("/cdx/search/cdx?#{query.to_query_string}") do |response|
        body_io = process_body_io(response)
        Protocol::SnapshotsParser.call(body_io)
      end
    end

    private def process_body_io(response : HTTP::Client::Response) : IO
      body_io = response.body_io
      content_encoding = response.headers["Content-Encoding"]?
      case content_encoding
      when "gzip"
        Compress::Gzip::Reader.new(body_io, sync_close: true)
      when "deflate"
        Compress::Deflate::Reader.new(body_io, sync_close: true)
      else
        body_io
      end
    end
  end
end

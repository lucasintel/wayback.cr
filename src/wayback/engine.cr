require "./api"
require "csv"

module Wayback
  class Engine
    @api : Wayback::Api

    def initialize(*, api : Wayback::Api? = nil)
      @api = api || Wayback::Api.new
    end

    def snapshots(url : String, *, from : Time? = nil, to : Time? = nil, latest : Int32? = nil, earliest : Int32? = nil) : Array(Snapshot)
      query = Wayback::Query.url(url)
      query = query.from(from) if from
      query = query.to(to) if to
      query = query.earliest(earliest) if earliest
      query = query.latest(latest) if latest
      @api.perform(query)
    end

    def latest_snapshot(url : String) : Snapshot?
      query = Wayback::Query.url(url).latest(1)
      collection = @api.perform(query)
      collection.first?
    end

    def first_snapshot(url : String) : Snapshot?
      query = Wayback::Query.url(url).earliest(1)
      collection = @api.perform(query)
      collection.first?
    end

    def perform(query : Wayback::Query) : Array(Snapshot)
      @api.perform(query)
    end
  end
end

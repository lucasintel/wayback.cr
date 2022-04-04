require "./wayback/engine"

module Wayback
  class_getter default_engine : Wayback::Engine { Wayback::Engine.new }

  def self.snapshots(url : String, *, from : Time? = nil, to : Time? = nil, latest : Int32? = nil, earliest : Int32? = nil)
    default_engine.snapshots(url, from: from, to: to, latest: latest, earliest: earliest)
  end

  def self.latest_snapshot(url : String) : Snapshot?
    default_engine.latest_snapshot(url)
  end

  def self.first_snapshot(url : String) : Snapshot?
    default_engine.first_snapshot(url)
  end

  def self.perform(query : Wayback::Query) : Array(Snapshot)
    default_engine.perform(query)
  end
end

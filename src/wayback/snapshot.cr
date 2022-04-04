require "http/status"

struct Snapshot
  getter id : String
  getter resource : String
  getter time : Time
  getter status : HTTP::Status?
  getter mimetype : String
  getter digest : String
  getter content_length : UInt64
  getter url : String
  getter aggregate_count : Int32

  def initialize(
    @id : String,
    @resource : String,
    @time : Time,
    @status : HTTP::Status?,
    @mimetype : String,
    @digest : String,
    @content_length : UInt64,
    @url : String,
    @aggregate_count : Int32
  )
  end
end

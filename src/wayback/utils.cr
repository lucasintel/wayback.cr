module Wayback
  module Utils
    WAYBACK_MACHINE_TIMESTAMP_FORMAT = "%Y%m%d%H%M%S"

    def self.parse_timestamp(timestamp : String)
      Time.parse(timestamp, pattern: WAYBACK_MACHINE_TIMESTAMP_FORMAT, location: Time::Location::UTC)
    end

    def self.to_timestamp(time : Time)
      time.to_utc.to_s(WAYBACK_MACHINE_TIMESTAMP_FORMAT)
    end
  end
end

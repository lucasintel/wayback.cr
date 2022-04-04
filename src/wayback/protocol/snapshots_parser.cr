require "../utils"
require "csv"

module Wayback
  module Protocol
    module SnapshotsParser
      WAYBACK_MACHINE_BASE_URL = "https://web.archive.org/web"

      CDX_OUTPUT_SERPARATOR = ' '

      URLKEY          = 0
      TIMESTAMP       = 1
      ORIGINAL        = 2
      MIMETYPE        = 3
      STATUSCODE      = 4
      DIGEST          = 5
      LENGTH          = 6
      AGGREGATE_COUNT = 7

      def self.call(io : IO) : Array(Snapshot)
        snapshots = [] of Snapshot
        CSV.each_row(io, separator: CDX_OUTPUT_SERPARATOR) do |line|
          time = Utils.parse_timestamp(line[TIMESTAMP])
          status = HTTP::Status.from_value(line[STATUSCODE].to_i)
          url = "#{WAYBACK_MACHINE_BASE_URL}/#{line[TIMESTAMP]}/#{line[ORIGINAL]}"
          aggregate_count = line[AGGREGATE_COUNT]?.try(&.to_i) || 0
          snapshots << Snapshot.new(
            id: line[URLKEY],
            resource: line[ORIGINAL],
            time: time,
            status: status,
            mimetype: line[MIMETYPE],
            content_length: line[LENGTH].to_u64,
            digest: line[DIGEST],
            url: url,
            aggregate_count: aggregate_count,
          )
        end
        snapshots
      end
    end
  end
end

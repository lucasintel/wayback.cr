require "../src/wayback.cr"

query = Wayback::Query.url("https://kyivindependent.com/*")
  .latest(100)
  .group_by_url
  .with_aggregate_count
snapshots = Wayback.perform(query)
snapshots.each do |snapshot|
  puts snapshot
end

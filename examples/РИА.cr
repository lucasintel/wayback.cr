require "../src/wayback.cr"

snapshots = Wayback.snapshots("https://ria.ru/", latest: 10)
snapshots.each do |snapshot|
  puts snapshot
end

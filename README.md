# Wayback

The [Internet Archive](https://archive.org/)'s **⏳Wayback Machine** interface for Crystal.

[![CI](https://github.com/kandayo/wayback.cr/actions/workflows/ci.yml/badge.svg)](https://github.com/kandayo/wayback.cr/actions/workflows/ci.yml)
[![GitHub release](https://img.shields.io/github/release/kandayo/wayback.cr.svg?label=Release)](https://github.com/kandayo/wayback.cr/releases)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     wayback:
       github: kandayo/wayback.cr
   ```

2. Run `shards install`

## Usage

#### Retrieve the latest snapshot for a given page

```crystal
Wayback.latest_snapshot("https://ukraine.ua/")
```

#### Retrieve snapshots for a given page by a date range

```crystal
Wayback.snapshots("https://ukraine.ua/", from: 1.month.ago, to: Time.local)
```

#### Retrieve the latest 10 snapshots under a given path

```crystal
Wayback.snapshots("https://ukraine.ua/*", latest: 10)
```

#### Retrieve the first snapshot for a given page

```crystal
Wayback.first_snapshot("https://ukraine.ua/")
```

## Advanced usage

The library provides a straightforward interface for building complex queries as well.

```crystal
Wayback::Query.url("https://ukraine.ua/*")
  .from(1.year.ago)
  .to(Time.local)
  .mime_type(/image\/*./)
  .status_not(301)
  .status_not(404)
  .latest(10)
```

```crystal
Wayback.perform(query)
```

### Grouping

Aggregate snapshots based on a field, or a substring (`position`) of a field.

```crystal
# 📰 news headlines by day
query = Wayback::Query.url("https://kyivindependent.com/").group_by_day
Wayback.perform(query)
```

It's possible to track how many snapshots were skipped due to **filtering** and
**grouping** by including `#with_aggregate_count` in the chain. This feature is optional
since it might slow down the query.

```crystal
# Unique captures per URL.
query = Wayback::Query.url("https://kyivindependent.com/*").group_by_url.with_aggregate_count
snapshots = Wayback.perform(query)
snapshots.first.url
# => https://kyivindependent.com/opinion/natalia-datskevych-my-rescue-mission-to-flee-russias-war-with-three-kids/
snapshots.first.aggregate_count
# => 5
```

### Low level API

```crystal
params = {
  "url"      => "https://kyivindependent.com/",
  "filter"   => "!status:404",
  "collapse" => "timestamp:10",
}
Wayback.execute(params)
```

## References

- [Wayback Machine CDX-Server API](https://github.com/internetarchive/wayback/blob/master/wayback-cdx-server/README.md)
- [A Sustainable, Large-Scale, Minimal Approach to Accessing Web Archives](https://web.archive.org/web/20220116031116/https://archive-it.org/blog/post/a-sustainable-large-scale-minimal-approach-to-accessing-web-archives/) (Greg Wiedeman, archivist at the University At Albany)
- [Wayback Machine APIs](https://archive.org/help/wayback_api.php)
- [The CDX File Format](https://archive.org/web/researcher/cdx_file_format.php)

## Contributing

1. Fork it (<https://github.com/kandayo/wayback.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Lucas M. D.](https://github.com/kandayo) - creator and maintainer

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

#### Find the latest snapshot of a given page

```crystal
Wayback.latest_snapshot("https://ria.ru")
```

### Find snapshots of a a given page by date range

```crystal
Wayback.snapshots("https://ria.ru", from: 1.month.ago, to: Time.local)
```

### Find the latest 10 snapshots under a given path

```crystal
Wayback.snapshots("https://ria.ru/*", latest: 10)
```

#### Find the first snapshot of a given page

```crystal
Wayback.first_snapshot("https://ria.ru")
```

## Advanced queries

```crystal
query = Wayback::Query.url("https://ria.ru/*").from(1.month.ago).mime_type(/image\/*./).status_not(404).latest(10)

Wayback.perform(query)
```

## References

- [Wayback Machine CDX-Server API](https://github.com/internetarchive/wayback/blob/master/wayback-cdx-server/README.md)
- [A Sustainable, Large-Scale, Minimal Approach to Accessing Web Archives](https://web.archive.org/web/20220116031116/https://archive-it.org/blog/post/a-sustainable-large-scale-minimal-approach-to-accessing-web-archives/) (Greg Wiedeman, University At Albany)
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

Changes
=======

# 1.22.0 / 2016-04-14
This release breaks compatibility with Ruby 1.8.
* [FEATURE] Metric query API. See [#88][], [#90][] (thanks [@blakehilscher][])

# 1.21.0 / 2015-10-30
This is the last release compatible with Ruby 1.8. ([EOL 2013-06-30](https://www.ruby-lang.org/en/news/2013/06/30/we-retire-1-8-7/))
* [FEATURE] User CRUD API. See [#82][]
* [IMPROVEMENT] Support capistrano SimpleTextFormatter (thanks [@rmoriz][] [#81][])

# 1.20.0 / 2015-07-29
* [FEATURE] Embeddable graphs API. See [#73][]

# 1.19.0 / 2015-06-22
* [FEATURE] Revoke a shared a Screenboard. See [#69][]

# 1.18.0 / 2015-06-01
* [FEATURE] Add support for host muting.

# 1.17.0 / 2015-03-26
* [IMPROVEMENT] Use MultiJSON for JSON handling. (thanks [@winebarrel][] [#64][])

# 1.16.0 / 2015-03-06
* [IMPROVEMENT] Return response from API when metrics are sent as a batch. (thanks [@yyuu][] [#62](https://github.com/DataDog/dogapi-rb/pull/62))

# 1.15.0 / 2015-02-03
* [BUGFIX] Add open_timeout to avoid stuck HTTP calls (thanks [@Kaixiang][] [#55](https://github.com/DataDog/dogapi-rb/pull/55))
* [BUGFIX] Encode capistrano output messages to UTF-8 before manipulating them. (thanks [@byroot][] [#52](https://github.com/DataDog/dogapi-rb/pull/52))

# 1.14.0 / 2015-01-09
* [FEATURE] Add get_all_screenboards [#61](https://github.com/DataDog/dogapi-rb/pull/61)
* [IMPROVEMENT] Remove required start argument from schedule_downtime [#60](https://github.com/DataDog/dogapi-rb/pull/60)

# 1.13.0 / 2014-12-10
* [FEATURE] Add tag filter to get_all_monitors [#58](https://github.com/DataDog/dogapi-rb/pull/58)
* [FEATURE] Add update downtime method [#59](https://github.com/DataDog/dogapi-rb/pull/59)

# 1.12.0 / 2014-11-17
* [FEATURE] Add support for the Monitor API [#51](https://github.com/DataDog/dogapi-rb/pull/51)
* [IMPROVEMENT] Truncate event title and text before submission [#53](https://github.com/DataDog/dogapi-rb/pull/53)

# 1.11.0 / 2014-07-03
* [IMPROVEMENT] Add support for HTTP proxy defined by the environment variables
* [IMPROVEMENT] Allow to send several metrics in the same HTTP request

# 1.10.0 / 2014-05-13
* [IMPROVEMENT] Make HTTP timeout configurable ([#29](https://github.com/DataDog/dogapi-rb/issues/29))
* [IMPROVEMENT] Re-enable SSL verification ([#37](https://github.com/DataDog/dogapi-rb/issues/37))
* [IMPROVEMENT] Report application name when deploy with Capistrano (thanks [@ArjenSchwarz][] [#46](https://github.com/DataDog/dogapi-rb/pull/46))

# 1.9.2 / 2014-02-13
* [IMPROVEMENT] Fully support for capistrano v3 ([#43](https://github.com/DataDog/dogapi-rb/pull/43))
* [IMPROVEMENT] Strip control characters from capistrano messages ([#36](https://github.com/DataDog/dogapi-rb/issues/36))
* [IMPROVEMENT] Tag capistrano events by stage (thanks [@arielo][] [#25](https://github.com/DataDog/dogapi-rb/pull/25))

# 1.9.1 / 2014-01-06
* [IMPROVEMENT] Log a warning instead of crashing when trying to integration with capistrano v3

# 1.9.0 / 2013-09-06
* [IMPROVEMENT] When emitting a metric without an explicit host, default to local hostname.

# 1.8.1 / 2013-08-22
* [FEATURE] Update Dash API to support template variables.

# 1.8.0 / 2013-07-16
* [FEATURE] Add an API for interacting with Screenboards

# 1.7.1 / 2013-06-23
* [BUGFIX] Fix bug in capistrano integration with logging of nil (thanks [@arielo][])
* [FEATURE] Add an API for inviting users
* [FEATURE] Add an API for taking graph snapshots

# 1.7.0
* Not released.

# 1.6.0 / 2013-02-19
* [FEATURE] Support for setting `source` type when submitting host tags

# 1.5.2 / 2013-02-13
* [BUGFIX] Fix a bug in hashing the Event object when the instance variables are symbols.

# 1.5.0 / 2012-11-06
* [FEATURE] Alerting API

# 1.4.3
* [BUGFIX] Fix bug with capistrano integration for capistrano 2.13.5 (thanks [@ansel1][])

# 1.4.2
* [BUGFIX] Added missing dashboards endpoint.

# 1.4.1
* [BUGFIX] Fixed searching for events with tags.

# 1.4.0
* [FEATURE] Added support for the dashboard, search and comment API endpoints.

# 1.3.6
* [BUGFIX] Small fix for capistrano integration

# 1.3.4
* [BUGFIX] Various bug fixes (event.to_hash, md5 import, capistrano lambda roles)

# 1.3.3
* [BUGFIX] Bug fix for submitting counters

# 1.3.2
* [IMPROVEMENT] Support an aggregation key to aggregate events together

# 1.3.1
* [FEATURE] Metrics can be counters, rather than just gauges (thanks to [@treeder][])
* [FEATURE] Metrics can be tagged.

# 1.3.0
* [FEATURE] Capistrano integration. See https://github.com/DataDog/dogapi-rb/tree/master/lib/capistrano

# 1.2.x
* [FEATURE] You can now manage host tags
* [IMPROVEMENT] Functionality relating to events with a duration has been deprecated
* [IMPROVEMENT] The underlying clients have been updated to use Datadog's new public HTTP API[https://github.com/DataDog/dogapi/wiki]
* [IMPROVEMENT] You can now get event details and query the stream in addition to posting events

# 1.1.x
* [IMPROVEMENT] You do not need to use environment variables anymore to use the client.

<!--- The following link definition list is generated by PimpMyChangelog --->
[#25]: https://github.com/DataDog/dogapi-rb/issues/25
[#29]: https://github.com/DataDog/dogapi-rb/issues/29
[#36]: https://github.com/DataDog/dogapi-rb/issues/36
[#37]: https://github.com/DataDog/dogapi-rb/issues/37
[#43]: https://github.com/DataDog/dogapi-rb/issues/43
[#46]: https://github.com/DataDog/dogapi-rb/issues/46
[#51]: https://github.com/DataDog/dogapi-rb/issues/51
[#52]: https://github.com/DataDog/dogapi-rb/issues/52
[#53]: https://github.com/DataDog/dogapi-rb/issues/53
[#55]: https://github.com/DataDog/dogapi-rb/issues/55
[#58]: https://github.com/DataDog/dogapi-rb/issues/58
[#59]: https://github.com/DataDog/dogapi-rb/issues/59
[#60]: https://github.com/DataDog/dogapi-rb/issues/60
[#61]: https://github.com/DataDog/dogapi-rb/issues/61
[#62]: https://github.com/DataDog/dogapi-rb/issues/62
[#64]: https://github.com/DataDog/dogapi-rb/issues/64
[#69]: https://github.com/DataDog/dogapi-rb/issues/69
[#73]: https://github.com/DataDog/dogapi-rb/issues/73
[#81]: https://github.com/DataDog/dogapi-rb/issues/81
[#82]: https://github.com/DataDog/dogapi-rb/issues/82
[#88]: https://github.com/DataDog/dogapi-rb/issues/88
[#90]: https://github.com/DataDog/dogapi-rb/issues/90
[@ArjenSchwarz]: https://github.com/ArjenSchwarz
[@Kaixiang]: https://github.com/Kaixiang
[@ansel1]: https://github.com/ansel1
[@arielo]: https://github.com/arielo
[@blakehilscher]: https://github.com/blakehilscher
[@byroot]: https://github.com/byroot
[@rmoriz]: https://github.com/rmoriz
[@treeder]: https://github.com/treeder
[@winebarrel]: https://github.com/winebarrel
[@yyuu]: https://github.com/yyuu

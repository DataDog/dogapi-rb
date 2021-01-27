# Changes

## 1.45.0 / 2021-01-27

* [Added] Read `datadog_host` cap variable for specifying Datadog API endpoint. See [#255](https://github.com/DataDog/dogapi-rb/pull/255).
* [Added] Added support for logs pipelines CRUD methods. See [#252](https://github.com/DataDog/dogapi-rb/pull/252). Thanks [hi-artem](https://github.com/hi-artem).
* [Fixed] Properly handle string response code. See [#254](https://github.com/DataDog/dogapi-rb/pull/254).
* [Fixed] Remove circular dependency. See [#253](https://github.com/DataDog/dogapi-rb/pull/253).

## 1.44.0 / 2020-12-10

* [Added] Allow skipping SSL verification. See [#246](https://github.com/DataDog/dogapi-rb/pull/246).

## 1.43.0 / 2020-12-07

* [Fixed] find_localhost: Try both `hostname` and `hostname -f` before raising. See [#242](https://github.com/DataDog/dogapi-rb/pull/242).

## 1.42.0 / 2020-09-17

* [Added] Allow dashboard creation / updates using Template Variable Presets. See [#238](https://github.com/DataDog/dogapi-rb/pull/238).

## 1.41.0 / 2020-07-27

* [Added] Improve user-agent header to include telemetry information. See [#235](https://github.com/DataDog/dogapi-rb/pull/235).
* [Added] Move setting hostname to end of method body in order to actually return it. See [#233](https://github.com/DataDog/dogapi-rb/pull/233).

## 1.40.0 / 2020-04-06

* [Added] Re-add service level objectives support. See [#224](https://github.com/DataDog/dogapi-rb/pull/224).

## 1.39.0 / 2020-02-04

* [Added] Allow Setting Proxy without Using HTTP_PROXY, etc.. See [#180](https://github.com/DataDog/dogapi-rb/pull/180). Thanks [KingAlex42](https://github.com/KingAlex42).
* [Added] [capistrano] Add ability to use `etc.getpwuid` instead of `etc.getlogin` to get the user name. See [#146](https://github.com/DataDog/dogapi-rb/pull/146). Thanks [rkul](https://github.com/rkul).
* [Fixed] Check exit code of `hostname -f` for failures. See [#219](https://github.com/DataDog/dogapi-rb/pull/219).
* [Added] Add `validate_tags` util to check that `tags` is an array of strings. See [#218](https://github.com/DataDog/dogapi-rb/pull/218).
* [Added] Added function to deal with redirection of HTTP requests. See [#200](https://github.com/DataDog/dogapi-rb/pull/200).
* [Added] Add Synthetics support. See [#210](https://github.com/DataDog/dogapi-rb/pull/210).
* [Added] Add dashboard read_only option. See [#135](https://github.com/DataDog/dogapi-rb/pull/135). Thanks [tjoyal](https://github.com/tjoyal).
* [Added] Add options for force delete monitors. See [#213](https://github.com/DataDog/dogapi-rb/pull/213).

## 1.38.0 / 2019-12-13

* [BUGFIX] Fix setting keys in both query params and headers. See [#194][]
* [BUGFIX] Fix `cancel_downtime_by_scope` method by setting `send_json` to `true`. See [#205][]
* [FEATURE] Add Azure, GCP, AWS, and AWS Logs integration support. See [#201][]
* [FEATURE] Add support for new `Monitor.can_delete` endpoint. See [#195][]
* [FEATURE] Add `options` to the `get_downtime` endpoint. See [#206][]

## 1.37.1 / 2019-11-04

* [BUGFIX] Revert the Service Level Objective feature to remove an issue with older versions of Ruby < 2.0. See [#198][]

## 1.37.0 / 2019-11-04

* [FEATURE] Add Service Level Objectives support. See [#188][], thanks [@platinummonkey][]
* [IMPROVEMENTS] Don't fail if `hostname` binary is not installed. See [#179][], thanks [@pschipitsch][]
* [IMPROVEMENTS] Use headers-only for api and app keys for endpoints that support this. See [#189][], thanks [@ssc3][]
* [IMPROVEMENTS] Make `query` and `options` optional for `update_monitor` calls. See [#192][], thanks [@unclebconnor][]

## 1.36.0 / 2019-06-05

* [BUGFIX] Pass the options as params to request, not body content. See [#157][], thanks [@wonko][]
* [FEATURE] Add support for dashboard list API v2. See [#174][]
* [IMPROVEMENT] Add `get_active_metrics` and `resolve_monitors` methods for missing api endpoints. See [#172][]
* [IMPROVEMENT] Add methods for missing hourly usage api endpoints. See [#173][]

## 1.35.0 / 2019-03-21

* [FEATURE] Add get_all_boards and support for 'free' layout. See [#171][].

## 1.34.0 / 2019-03-08

* [FEATURE] Add /integration endpoints. See [#170][], thanks [@davidcpell][].

## 1.33.0 / 2019-02-13

* [IMPROVEMENT] Add submission types mentioned in the API documentation. See [#165][], thanks [@TaylURRE][]
* [FEATURE] Add support for the new Dashboard API. See [#167][], thanks [@enbashi][]

## 1.32.0 / 2018-10-23

* [FEATURE] Added [monitor search](https://docs.datadoghq.com/api/?lang=ruby#monitors-search) and [monitor groups search](https://docs.datadoghq.com/api/?lang=ruby#monitors-group-search) API endpoints. See [#163][].
* [FIX] Add project metadata to the gemspec. See [#162][], thanks [@orien][].

## 1.31.0 / 2018-10-01

* [FIX] Handle nil values from benchmarks in Capistrano. See [#159][].
* [IMPROVEMENT] Add getter/setter for datadog_host. See [#160][].

## 1.30 / 2018-06-05

* [FIX] Change API endpoint. See [#147][].
* [FIX] Show more friendly error message with non JSON responses. See [#151][], thanks [@edwardkenfox][].
* [FEATURE] Add hosts endpoints. See [#152][].

## 1.29.0 / 2018-03-23

* [FEATURE] Add new endpoints for dashboard lists.
* [IMPROVEMENT] change http-method GET to POST on api.Screenboard#share. See [#136][] (thanks [@haohcraft][])

## 1.28.0 / 2017-08-16

* [FEATURE] Accept `group_states` strings for `get_monitor` function. See [#132][] (thanks [@acroos][])
* [FEATURE] Add cancel\_by\_scope endpoint. See [#133][] (thanks [@martinisoft][])

## 1.27.0 / 2017-05-01

* [FEATURE] Add monitor validation endpoint. See [#127][]

## 1.26.0 / 2017-04-10

* [IMPROVEMENT] Allow additional options to be passed to monitor API calls. See [#125][] (thanks [@jimmyngo][])

## 1.25.0 / 2017-02-14

* [FEATURE] Add Datadog endpoint for metrics metadata. See [#120][]

## 1.24.0 / 2017-01-12

* [FEATURE] Add the ability to record events per host and to filter events. See [#115][] (thanks [@hnovikov][])
* [BUGFIX] Encode extra\_params to handle spaces. See [#113][] (thanks [@miknight][])
* [BUGFIX] Fix CaptureIO delegation and output with Capistrano >= 3.5. See [#114][] (thanks [@casperisfine][])

## 1.23.0 / 2016-08-24

* [FEATURE] Add Datadog endpoint to configuration. See [#108][]
* [FEATURE] Add delete method for events. See [#99][], [#109][]
* [IMPROVEMENT] Add Capistrano 3.5+ compatibility. See [#96][]
* [OTHER] Code style fixes. See [#106][] (thanks [@nots][])

## 1.22.0 / 2016-04-14
This release breaks compatibility with Ruby 1.8.
* [FEATURE] Metric query API. See [#88][], [#90][] (thanks [@blakehilscher][])

## 1.21.0 / 2015-10-30
This is the last release compatible with Ruby 1.8. ([EOL 2013-06-30](https://www.ruby-lang.org/en/news/2013/06/30/we-retire-1-8-7/))
* [FEATURE] User CRUD API. See [#82][]
* [IMPROVEMENT] Support capistrano SimpleTextFormatter (thanks [@rmoriz][] [#81][])

## 1.20.0 / 2015-07-29
* [FEATURE] Embeddable graphs API. See [#73][]

## 1.19.0 / 2015-06-22
* [FEATURE] Revoke a shared a Screenboard. See [#69][]

## 1.18.0 / 2015-06-01
* [FEATURE] Add support for host muting.

## 1.17.0 / 2015-03-26
* [IMPROVEMENT] Use MultiJSON for JSON handling. (thanks [@winebarrel][] [#64][])

## 1.16.0 / 2015-03-06
* [IMPROVEMENT] Return response from API when metrics are sent as a batch. (thanks [@yyuu][] [#62](https://github.com/DataDog/dogapi-rb/pull/62))

## 1.15.0 / 2015-02-03
* [BUGFIX] Add open_timeout to avoid stuck HTTP calls (thanks [@Kaixiang][] [#55](https://github.com/DataDog/dogapi-rb/pull/55))
* [BUGFIX] Encode capistrano output messages to UTF-8 before manipulating them. (thanks [@byroot][] [#52](https://github.com/DataDog/dogapi-rb/pull/52))

## 1.14.0 / 2015-01-09
* [FEATURE] Add get_all_screenboards [#61](https://github.com/DataDog/dogapi-rb/pull/61)
* [IMPROVEMENT] Remove required start argument from schedule_downtime [#60](https://github.com/DataDog/dogapi-rb/pull/60)

## 1.13.0 / 2014-12-10
* [FEATURE] Add tag filter to get_all_monitors [#58](https://github.com/DataDog/dogapi-rb/pull/58)
* [FEATURE] Add update downtime method [#59](https://github.com/DataDog/dogapi-rb/pull/59)

## 1.12.0 / 2014-11-17
* [FEATURE] Add support for the Monitor API [#51](https://github.com/DataDog/dogapi-rb/pull/51)
* [IMPROVEMENT] Truncate event title and text before submission [#53](https://github.com/DataDog/dogapi-rb/pull/53)

## 1.11.0 / 2014-07-03
* [IMPROVEMENT] Add support for HTTP proxy defined by the environment variables
* [IMPROVEMENT] Allow to send several metrics in the same HTTP request

## 1.10.0 / 2014-05-13
* [IMPROVEMENT] Make HTTP timeout configurable ([#29](https://github.com/DataDog/dogapi-rb/issues/29))
* [IMPROVEMENT] Re-enable SSL verification ([#37](https://github.com/DataDog/dogapi-rb/issues/37))
* [IMPROVEMENT] Report application name when deploy with Capistrano (thanks [@ArjenSchwarz][] [#46](https://github.com/DataDog/dogapi-rb/pull/46))

## 1.9.2 / 2014-02-13
* [IMPROVEMENT] Fully support for capistrano v3 ([#43](https://github.com/DataDog/dogapi-rb/pull/43))
* [IMPROVEMENT] Strip control characters from capistrano messages ([#36](https://github.com/DataDog/dogapi-rb/issues/36))
* [IMPROVEMENT] Tag capistrano events by stage (thanks [@arielo][] [#25](https://github.com/DataDog/dogapi-rb/pull/25))

## 1.9.1 / 2014-01-06
* [IMPROVEMENT] Log a warning instead of crashing when trying to integration with capistrano v3

## 1.9.0 / 2013-09-06
* [IMPROVEMENT] When emitting a metric without an explicit host, default to local hostname.

## 1.8.1 / 2013-08-22
* [FEATURE] Update Dash API to support template variables.

## 1.8.0 / 2013-07-16
* [FEATURE] Add an API for interacting with Screenboards

## 1.7.1 / 2013-06-23
* [BUGFIX] Fix bug in capistrano integration with logging of nil (thanks [@arielo][])
* [FEATURE] Add an API for inviting users
* [FEATURE] Add an API for taking graph snapshots

## 1.7.0
* Not released.

## 1.6.0 / 2013-02-19
* [FEATURE] Support for setting `source` type when submitting host tags

## 1.5.2 / 2013-02-13
* [BUGFIX] Fix a bug in hashing the Event object when the instance variables are symbols.

## 1.5.0 / 2012-11-06
* [FEATURE] Alerting API

## 1.4.3
* [BUGFIX] Fix bug with capistrano integration for capistrano 2.13.5 (thanks [@ansel1][])

## 1.4.2
* [BUGFIX] Added missing dashboards endpoint.

## 1.4.1
* [BUGFIX] Fixed searching for events with tags.

## 1.4.0
* [FEATURE] Added support for the dashboard, search and comment API endpoints.

## 1.3.6
* [BUGFIX] Small fix for capistrano integration

## 1.3.4
* [BUGFIX] Various bug fixes (event.to_hash, md5 import, capistrano lambda roles)

## 1.3.3
* [BUGFIX] Bug fix for submitting counters

## 1.3.2
* [IMPROVEMENT] Support an aggregation key to aggregate events together

## 1.3.1
* [FEATURE] Metrics can be counters, rather than just gauges (thanks to [@treeder][])
* [FEATURE] Metrics can be tagged.

## 1.3.0
* [FEATURE] Capistrano integration. See https://github.com/DataDog/dogapi-rb/tree/master/lib/capistrano

## 1.2.x
* [FEATURE] You can now manage host tags
* [IMPROVEMENT] Functionality relating to events with a duration has been deprecated
* [IMPROVEMENT] The underlying clients have been updated to use Datadog's new public HTTP API[https://github.com/DataDog/dogapi/wiki]
* [IMPROVEMENT] You can now get event details and query the stream in addition to posting events

## 1.1.x
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
[#96]: https://github.com/DataDog/dogapi-rb/issues/96
[#99]: https://github.com/DataDog/dogapi-rb/issues/99
[#106]: https://github.com/DataDog/dogapi-rb/issues/106
[#108]: https://github.com/DataDog/dogapi-rb/issues/108
[#109]: https://github.com/DataDog/dogapi-rb/issues/109
[#113]: https://github.com/DataDog/dogapi-rb/issues/113
[#114]: https://github.com/DataDog/dogapi-rb/issues/114
[#115]: https://github.com/DataDog/dogapi-rb/issues/115
[#120]: https://github.com/DataDog/dogapi-rb/issues/120
[#125]: https://github.com/DataDog/dogapi-rb/issues/125
[#127]: https://github.com/DataDog/dogapi-rb/issues/127
[#132]: https://github.com/DataDog/dogapi-rb/issues/132
[#133]: https://github.com/DataDog/dogapi-rb/issues/133
[#136]: https://github.com/DataDog/dogapi-rb/issues/136
[#147]: https://github.com/DataDog/dogapi-rb/issues/147
[#151]: https://github.com/DataDog/dogapi-rb/issues/151
[#152]: https://github.com/DataDog/dogapi-rb/issues/152
[#157]: https://github.com/DataDog/dogapi-rb/issues/157
[#159]: https://github.com/DataDog/dogapi-rb/issues/159
[#160]: https://github.com/DataDog/dogapi-rb/issues/160
[#162]: https://github.com/DataDog/dogapi-rb/issues/162
[#163]: https://github.com/DataDog/dogapi-rb/issues/163
[#165]: https://github.com/DataDog/dogapi-rb/issues/165
[#167]: https://github.com/DataDog/dogapi-rb/issues/167
[#170]: https://github.com/DataDog/dogapi-rb/issues/170
[#171]: https://github.com/DataDog/dogapi-rb/issues/171
[#172]: https://github.com/DataDog/dogapi-rb/issues/172
[#173]: https://github.com/DataDog/dogapi-rb/issues/173
[#174]: https://github.com/DataDog/dogapi-rb/issues/174
[#179]: https://github.com/DataDog/dogapi-rb/issues/179
[#188]: https://github.com/DataDog/dogapi-rb/issues/188
[#189]: https://github.com/DataDog/dogapi-rb/issues/189
[#192]: https://github.com/DataDog/dogapi-rb/issues/192
[#194]: https://github.com/DataDog/dogapi-rb/issues/194
[#195]: https://github.com/DataDog/dogapi-rb/issues/195
[#198]: https://github.com/DataDog/dogapi-rb/issues/198
[#201]: https://github.com/DataDog/dogapi-rb/issues/201
[#205]: https://github.com/DataDog/dogapi-rb/issues/205
[#206]: https://github.com/DataDog/dogapi-rb/issues/206
[@ArjenSchwarz]: https://github.com/ArjenSchwarz
[@Kaixiang]: https://github.com/Kaixiang
[@TaylURRE]: https://github.com/TaylURRE
[@acroos]: https://github.com/acroos
[@ansel1]: https://github.com/ansel1
[@arielo]: https://github.com/arielo
[@blakehilscher]: https://github.com/blakehilscher
[@byroot]: https://github.com/byroot
[@casperisfine]: https://github.com/casperisfine
[@davidcpell]: https://github.com/davidcpell
[@edwardkenfox]: https://github.com/edwardkenfox
[@enbashi]: https://github.com/enbashi
[@haohcraft]: https://github.com/haohcraft
[@hnovikov]: https://github.com/hnovikov
[@jimmyngo]: https://github.com/jimmyngo
[@martinisoft]: https://github.com/martinisoft
[@miknight]: https://github.com/miknight
[@nots]: https://github.com/nots
[@orien]: https://github.com/orien
[@platinummonkey]: https://github.com/platinummonkey
[@pschipitsch]: https://github.com/pschipitsch
[@rmoriz]: https://github.com/rmoriz
[@ssc3]: https://github.com/ssc3
[@treeder]: https://github.com/treeder
[@unclebconnor]: https://github.com/unclebconnor
[@winebarrel]: https://github.com/winebarrel
[@wonko]: https://github.com/wonko
[@yyuu]: https://github.com/yyuu

# Releasing

This document summarizes the process of doing a new release of this project.
Release can only be performed by Datadog maintainers of this repository.

## Schedule
This project does not have a strict release schedule. However, we would make a release at least every 2 months.
  - No release will be done if no changes got merged to the `master` branch during the above mentioned window.
  - Releases may be done more frequently than the above mentioned window.

## Prerelease checklist

* Check and upgrade dependencies where it applies and makes sense.
  - Create a distinct pull request and test your changes since it maybe introduce regressions.
  - While using the latest versions of dependencies is advised, it may not always be possible due to potential compatibility issues.
  - Upgraded dependencies should be thoroughly considered and tested to ensure they are safe!
* Make sure tests are passing.
  - Locally and in the continuous integration system.
* Manually test changes included in the new release.
* Make sure documentation is up-to-date.
* [Update changelog](#update-changelog)
  - Create a distinct pull request.

## Update Changelog

### Prerequisite

- Install [datadog_checks_dev](https://datadog-checks-base.readthedocs.io/en/latest/datadog_checks_dev.cli.html#installation) using Python 3.

### Commands

- See changes ready for release by running `ddev release show changes .` at the root of this project. Add any missing labels to PRs if needed.
- Run `ddev release changelog . <NEW_VERSION>` to update the `CHANGELOG.md` file at the root of this repository
- Commit the changes to the repository in a release branch and get it approved/merged.

## Release Process

### Prerequisite

Install [bundler](https://bundler.io/) and setup your RubyGems credentials:
1. Register an account on https://rubygems.org/
1. *Datadog Admins only* - Be assigned to Datadog's RubyGems gems by an owner*.
1. Set a `~/.gem/credentials` file as the following:
```
---
:rubygems_api_key: $RUBYGEMS_APIKEY
```

### Release

1. Tag the release with an annotated tag (based on your generated changelog), e.g.: `git tag -m"1.30" 1.30 `.
1. Update the gem version number in `lib/dogapi/version.rb`, create a PR and merge it. 
1. Build the gem: `bundle exec gem build dogapi.gemspec`.
1. Push the gem: `bundle exec gem push dogapi-x.x.x.gem`.
1. Create a release in the [Github releases page](https://github.com/DataDog/dogapi-rb/releases), it's ok to copy&paste from the changelog directly.
1. Check [Ruby Gem is published](https://rubygems.org/gems/dogapi).

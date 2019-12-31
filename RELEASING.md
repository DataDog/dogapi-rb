# Releasing

This document summarizes the process of doing a new release of this project.
Release can only be performed by Datadog maintainers of this repository.

## Schedule
This project does not have a strict release schedule. However, we would make a release at least every 2 months.
  - No release will be done if no changes got merged to the `master` branch during the above mentioned window.
  - Releases may be done more frequently than the above mentioned window.
  - Create a pager duty schedule corresponding to this.
  - Create a google calendar schedule corresponding to this.

## Make Sure Everything Works

// TODO

## Update Changelog

### Prerequisite

- Install [datadog_checks_dev](https://datadog-checks-base.readthedocs.io/en/latest/datadog_checks_dev.cli.html#installation) using Python 3.

### Commands

- See changes ready for release by running `ddev release show changes .` at the root of this project. Add any missing labels to PRs if needed.
- Run `ddev release changelog . <NEW_VERSION>` to update the `CHANGELOG.md` file at the root of this repository
- Commit the changes to the repository in a release branch and get it approved/merged.
- Tag the repository with the new version number.

## Release

- Update the [CHANGELOG](#commands) and [pimp it](https://github.com/pcreux/pimpmychangelog).
- Update the gem version number in `lib/dogapi/version.rb`.
- You could open a PR but committing the changes from the steps above directly on master is fine given the size of the project.
- Tag the release with an annotated tag, e.g.: `git tag -m"1.30" 1.30` .
- Push `master` to origin with `--tags`.
- Build the gem: `bundle exec gem build dogapi.gemspec`.
- Push the gem: `bundle exec gem push dogapi-x.x.x.gem`. 
- Create an entry in the [Github releases page](https://github.com/DataDog/dogapi-rb/releases), it's ok to copy&paste from the changelog directly.
- Check [Ruby Gem is published](https://rubygems.org/gems/dogapi).
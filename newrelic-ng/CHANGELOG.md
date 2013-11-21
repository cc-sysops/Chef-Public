# CHANGELOG for newrelic-ng

This file is used to list changes made in each version of newrelic-ng.

## 0.4.0:

* Add support for php-agent, thanks to Jeff Byrnes!

## 0.3.4:

* Add workaround for newrelic_generic_agent, was not starting up properly, due to bug in their status command

## 0.3.3:

* Install plugin-agent dependencies automatically
* KILL plugin-agent if TERM is not enough (after 10s)

## 0.3.2:

* Fix default recipe

## 0.3.1:

* Several small bugfixes, thanks to Cameron Johnston!

## 0.3.0:

* Adds support for generic newrelic agents (e.g. newrelic_nginx_agent, newrelic_sidekiq_agent)

## 0.2.0:

* Uses shared node['newrelic-ng']['license_key'] variable for all services
* Fix a problem with newrelic-plugin-agent service not starting up properly
* Migrate hashes to ruby-1.9 codestyle

## 0.1.0:

* Initial release of newrelic-ng

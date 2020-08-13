# Changelog

All notable changes to this project will be documented in this file.

## Release 0.1.6

* Add restapi_verify_client parameter.  ([PR #9](https://github.com/jadestorm/puppet-patroni/pull/9)) ([treydock](https://github.com/treydock))

## Release 0.1.5

* Properly fixed bug with bootstrap_users not being handled correctly (was broken before).  ([issue #7](https://github.com/jadestorm/puppet-patroni/issues/7)) ([rujim](https://github.com/rujim))

## Release 0.1.4

* Fixed bug with bootstrap_users not being handled correctly.  ([issue #7](https://github.com/jadestorm/puppet-patroni/issues/7))

## Release 0.1.3

* Added support for the latest consul configuration options - consistency, service_check_interval ([tomsajan](https://github.com/tomsajan))
* Added support for custom patroni service restart command (useful for reload only) ([tomsajan](https://github.com/tomsajan))
* Added support for Debian ([tomsajan](https://github.com/tomsajan))

## Release 0.1.2

### BREAKING CHANGES (sort of, didn't work previously)

* Updated the datatype of custom_conf to a String (Patroni uses custom_conf to define a file path and datatype can not be a Hash.) ([salindaliyanage](https://github.com/salindaliyanage))

### Other Changes

* Corrected a typo error in template (synchronous_mode_struct to synchronous_mode_strict) ([salindaliyanage](https://github.com/salindaliyanage))
* Added support for consul register_service configuration (This parameter decides whether or not to register a service with the name defined by the scope parameter and the tag master, replica or standby-leader depending on the node’s role.) ([salindaliyanage](https://github.com/salindaliyanage))
* Added support to merge pgsql_parameters defined in different levels of hiera. To merge the parameters, user should set the value of hiera_merge_pgsql_parameters to 'true'. ([salindaliyanage](https://github.com/salindaliyanage))

## Release 0.1.1

* Added option (restart_service) to configure whether you want the module to restart patroni. (default: false)

## Release 0.1.0

* Initial build, sets up and configures Patroni service.

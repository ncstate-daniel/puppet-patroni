
# patroni

[![Build Status](https://travis-ci.org/jadestorm/puppet-patroni.png?branch=master)](https://travis-ci.org/jadestorm/puppet-patroni)
[![Code Coverage](https://coveralls.io/repos/github/jadestorm/puppet-patroni/badge.svg?branch=master)](https://coveralls.io/github/jadestorm/puppet-patroni?branch=master)
[![Puppet Forge](https://img.shields.io/puppetforge/v/jadestorm/patroni.svg)](https://forge.puppetlabs.com/jadestorm/patroni)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/jadestorm/patroni.svg)](https://forge.puppetlabs.com/jadestorm/patroni)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/jadestorm/patroni.svg)](https://forge.puppetlabs.com/jadestorm/patroni)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/jadestorm/patroni.svg)](https://forge.puppetlabs.com/jadestorm/patroni)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with patroni](#setup)
    * [What patroni affects](#what-patroni-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with patroni](#beginning-with-patroni)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module sets up a Patroni instance, which provides seemless replication for PostgreSQL, allowing
you to run a load balanced and highly available PostgreSQL service.  It is one of many options for
HA with PostgreSQL, so please take a look at the myriad of other options to make sure you pick the one
that is right for your environment.

This module alone is not enough to run a fully HA and replicated service.  Please read up on your options
at [Patroni's GitHub Project](https://github.com/zalando/patroni).  In our case, we use haproxy, using [puppetlabs's haproxxy module](https://forge.puppet.com/puppetlabs/haproxy), and etcd, using [cristifalcas's etcd module](https://forge.puppet.com/cristifalcas/etcd).

## Setup

### What patroni affects

The patroni module sets up the following:

* Installs Patroni via package manager
* Sets up a systemd based service for Patroni
* Manages Patroni's configuration at /etc/patroni

### Setup Requirements

It is very important that you read up on [how Patroni works](https://github.com/zalando/patroni), as you will
also need a variety of other components to accomplish anything useful with Patroni.

You also need to make sure the patroni package is available somewhere.  For RPM based systems, you can
get the package from [here](https://github.com/cybertec-postgresql/patroni-packaging/releases).

You will also need to get PostgreSQL itself installed yourself.  Patroni handles starting PostgreSQL on it's own,
but you need to get the software installed.  One pretty easy recommendation I have is to simply pull in
[puppetlab's postgresql module](https://forge.puppet.com/puppetlabs/postgresql) and make use of the
::postgresql::globals class.  We will demonstrate a very simple recipe for that below.

### Beginning with patroni

The very basic steps needed for a user to get the module up and running. This can include setup steps, if necessary, or it can be an example of the most basic use of the module.

## Usage

This section is where you describe how to customize, configure, and do the fancy stuff with your module here. It's especially helpful if you include usage examples and code samples for doing things with your module.

## Reference

Users need a complete list of your module's classes, types, defined types providers, facts, and functions, along with the parameters for each. You can provide this list either via Puppet Strings code comments or as a complete list in the README Reference section.

* If you are using Puppet Strings code comments, this Reference section should include Strings information so that your users know how to access your documentation.

* If you are not using Puppet Strings, include a list of all of your classes, defined types, and so on, along with their parameters. Each element in this listing should include:

  * The data type, if applicable.
  * A description of what the element does.
  * Valid values, if the data type doesn't make it obvious.
  * Default value, if any.

## Limitations

This is currently only supported on RedHat based systems, and of the RHEL7 era and newer.

## Development

If you are interested in helping with development, please submit pull requests against
[https://github.com/jadestorm/puppet-patroni](https://github.com/jadestorm/puppet-patroni).
While Debian is not supported currently, I would absolutely welcome someone putting in the work to
add that support.  (I simply have no need of it)

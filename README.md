
# patroni

[![Build Status](https://travis-ci.org/jadestorm/puppet-patroni.png?branch=master)](https://travis-ci.org/jadestorm/puppet-patroni)
[![Code Coverage](https://coveralls.io/repos/github/jadestorm/puppet-patroni/badge.svg?branch=master)](https://coveralls.io/github/jadestorm/puppet-patroni?branch=master)
[![Puppet Forge](https://img.shields.io/puppetforge/v/jadestorm/patroni.svg)](https://forge.puppetlabs.com/jadestorm/patroni)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/jadestorm/patroni.svg)](https://forge.puppetlabs.com/jadestorm/patroni)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/jadestorm/patroni.svg)](https://forge.puppetlabs.com/jadestorm/patroni)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/jadestorm/patroni.svg)](https://forge.puppetlabs.com/jadestorm/patroni)

## Table of Contents

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

A bare minimum configuration might be:

```puppet
class { '::patroni':
  scope => 'mycluster',
}
```

If you specify `patroni::pgsql_parameters` at multiple levels in Hiera
and would like to merge them, add the following to your `common.yaml`
(or lowest priority Hiera level).

```yaml
lookup_options:
  patroni::pgsql_parameters:
    merge: deep
```

This assumes you have taken care of all of the rest of the components needed for Patroni.

## Usage

If you want to use PostgreSQL's own repositories, you could do something like:

```puppet
class { '::postgresql::globals':
  manage_package_repo => true,
}
package { 'postgresql96-server':
  ensure => present,
}
class { '::patroni':
  scope => 'mycluster',
}
```

A much more fleshed out example might be something like:

```puppet
# First PostgreSQL server
node pg1 {
  class { '::etcd':
    etcd_name                   => ${::hostname},
    listen_client_urls          => 'http://0.0.0.0:2379',
    advertise_client_urls       => "http://${::fqdn}:2379",
    listen_peer_urls            => 'http://0.0.0.0:2380',
    initial_advertise_peer_urls => "http://${::fqdn}:2380",
    initial_cluster             => [
      'pgarb=http://pgarb.example.org:2380',
      'pg1=http://pg1.example.org:2380',
      'pg2=http://pg2.example.org:2380',
    ],
    initial_cluster_state       => 'existing',
  }

  class { '::postgresql::globals':
    encoding            => 'UTF-8',
    locale              => 'en_US.UTF-8',
    manage_package_repo => true,
    version             => '9.6',
  }
  package { ['postgresql96-server','postgresql96-contrib']:
    ensure => present,
  }

  class { '::patroni':
    scope                   => 'mycluster',
    use_etcd                => true,
    pgsql_connect_address   => "${::fqdn}:5432",
    restapi_connect_address => "${::fqdn}:8008",
    pgsql_bin_dir           => '/usr/pgsql-9.6/bin',
    pgsql_data_dir          => '/var/lib/pgsql/9.6/data',
    pgsql_pgpass_path       => '/var/lib/pgsql/pgpass',
    pgsql_parameters        => {
      'max_connections' => 5000,
    },
    pgsql_pg_hba            => [
      'host all all 0.0.0.0/0 md5',
      'host replication rep_user 0.0.0.0/0 md5',
    ],
    superuser_username      => 'postgres',
    superuser_password      => 'somepassword',
    replication_username    => 'rep_user',
    replication_password    => 'someotherpassword',
  }
}
# Second PostgreSQL server
node pg2 {
  class { '::etcd':
    etcd_name                   => ${::hostname},
    listen_client_urls          => 'http://0.0.0.0:2379',
    advertise_client_urls       => "http://${::fqdn}:2379",
    listen_peer_urls            => 'http://0.0.0.0:2380',
    initial_advertise_peer_urls => "http://${::fqdn}:2380",
    initial_cluster             => [
      'pgarb=http://pgarb.example.org:2380',
      'pg1=http://pg1.example.org:2380',
      'pg2=http://pg2.example.org:2380',
    ],
    initial_cluster_state       => 'existing',
  }

  class { '::postgresql::globals':
    encoding            => 'UTF-8',
    locale              => 'en_US.UTF-8',
    manage_package_repo => true,
    version             => '9.6',
  }
  package { ['postgresql96-server','postgresql96-contrib']:
    ensure => present,
  }

  class { '::patroni':
    scope                   => 'mycluster',
    use_etcd                => true,
    pgsql_connect_address   => "${::fqdn}:5432",
    restapi_connect_address => "${::fqdn}:8008",
    pgsql_bin_dir           => '/usr/pgsql-9.6/bin',
    pgsql_data_dir          => '/var/lib/pgsql/9.6/data',
    pgsql_pgpass_path       => '/var/lib/pgsql/pgpass',
    pgsql_parameters        => {
      'max_connections' => 5000,
    },
    pgsql_pg_hba            => [
      'host all all 0.0.0.0/0 md5',
      'host replication rep_user 0.0.0.0/0 md5',
    ],
    superuser_username      => 'postgres',
    superuser_password      => 'somepassword',
    replication_username    => 'rep_user',
    replication_password    => 'someotherpassword',
  }
}
# Simple etcd arbitrator node, meaning it serves no content of it's own, just helps keep quorum
node pgarb {
  class { '::etcd':
    etcd_name                   => ${::hostname},
    listen_client_urls          => 'http://0.0.0.0:2379',
    advertise_client_urls       => "http://${::fqdn}:2379",
    listen_peer_urls            => 'http://0.0.0.0:2380',
    initial_advertise_peer_urls => "http://${::fqdn}:2380",
    initial_cluster             => [
      'pgarb=http://pgarb.example.org:2380',
      'pg1=http://pg1.example.org:2380',
      'pg2=http://pg2.example.org:2380',
    ],
    initial_cluster_state       => 'existing',
  }
}
```

## Reference

All of the Patroni settings I could find in the [Patroni Settings Documentation](https://github.com/zalando/patroni/blob/master/docs/SETTINGS.rst) are mapped to this module.
However, I do not have experience with the bulk of those settings, so implementing them here was done
as a best guess.

At some point all of the options will be documented here, but in the meantime, you can look at the
[init.pp](https://github.com/jadestorm/puppet-patroni/blob/master/manifests/init.pp) for the module to
see what all settings it accepts.  I hope to improve the documentation at some point, but wanted to get
this out there if others need it.

I also highly recommend checking out
[PostgreSQL High Availability Cookbook](https://www.amazon.com/PostgreSQL-High-Availability-Cookbook-Second/dp/178712553X)
as it is a fantastic resource for wrapping your head around all of the options and has a great walkthrough
for setting up Patroni.

## Limitations

This is currently only supported on RedHat Enterprise Linux 7 based systems.  I would love to
see support on other distributions and even OS's, so if you are interested in contributing please
do so!

## Development

If you are interested in helping with development, please submit pull requests against
[https://github.com/jadestorm/puppet-patroni](https://github.com/jadestorm/puppet-patroni).
While Debian is not supported currently, I would absolutely welcome someone putting in the work to
add that support.  (I simply have no need of it)

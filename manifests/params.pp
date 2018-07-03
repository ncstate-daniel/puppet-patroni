# Default parameters
class patroni::params {
  $ensure_package = 'present'
  $ensure_service = 'running'
  $enable_service = true
  $namespace      = '/service/'

  $dcs_loop_wait                = 10
  $dcs_ttl                      = 30
  $dcs_retry_timeout            = 10
  $dcs_maximum_lag_on_failover  = 1048576
  $dcs_master_start_timeout     = 300
  $dcs_synchronous_mode         = false
  $dcs_synchronous_mode_strict  = false
  $dcs_postgresql_use_pg_rewind = true
  $dcs_postgresql_use_slots     = true

  $bootstrap_method             = 'initdb'
  $initdb_data_checksums        = true
  $initdb_encoding              = 'UTF8'
  $initdb_locale                = 'UTF8'
  $bootstrap_pg_hba             = [
    'host all all 0.0.0.0/0 md5',
    'host replication replicator 127.0.0.1/32 md5',
  ]

  $superuser_username           = 'superuser'
  $superuser_password           = 'changeme'
  $replication_username         = 'replication'
  $replication_password         = 'changeme'

  $pgsql_connect_address        = '127.0.0.1:5432'
  $pgsql_create_replica_methods = ['basebackup']

  $pgsql_listen                 = '0.0.0.0:5432'
  $pgsql_use_unix_socket        = false
  $pgsql_pgpass_path            = '/tmp/pgpass0'

  $pgsql_pg_ctl_timeout         = 60
  $pgsql_use_pg_rewind          = true
  $pgsql_remove_data_directory_on_rewind_failure = false

  $use_consul    = false
  $consul_host   = 'localhost'
  $consul_port   = 8500
  $consul_scheme = 'http'

  $use_etcd      = false
  $etcd_host     = '127.0.0.1:2379'
  $etcd_protocol = 'http'

  $use_exhibitor           = false
  $exhibitor_poll_interval = 10
  $exhibitor_port          = 8080

  $use_kubernetes           = false
  $kubernetes_use_endpoints = false

  $restapi_connect_address = '127.0.0.1:8008'
  $restapi_listen          = '0.0.0.0:8008'

  $use_zookeeper = false

  $watchdog_mode          = 'automatic'
  $watchdog_device        = '/dev/watchdog'
  $watchdog_safety_margin = 5

  case $::osfamily {
    'RedHat': {
      $servicename = 'patroni'
      $packagename = 'patroni'
      $config_path = '/opt/app/patroni/etc/postgresql.yml'
      $config_owner = 'root'
      $config_group = 'root'
      $config_mode  = '0644'

      case $::operatingsystemmajrelease {
        7: {
          $pgsql_data_dir   = '/var/lib/pgsql/9.2/data'
          $pgsql_config_dir = $pgsql_data_dir
        }
        default: {
          fail { "This operating system version (${::operatingsystemmajrelease}) is not supported.": }
        }
      }
    }
    default: {
      fail { "This operating system family (${::osfamily}) is not supported.": }
    }
  }
}

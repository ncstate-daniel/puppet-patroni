# Sets up and configures a Patroni instance
class patroni (

  # Global Settings
  String $scope,
  String $namespace = $patroni::params::namespace,
  String $hostname  = $::hostname,

  # Bootstrap Settings
  Integer $dcs_loop_wait                = $patroni::params::dcs_loop_wait,
  Integer $dcs_ttl                      = $patroni::params::dcs_ttl,
  Integer $dcs_retry_timeout            = $patroni::params::retry_timeout,
  Integer $dcs_maximum_lag_on_failover  = $patroni::params::dcs_maximum_lag_on_failover,
  Integer $dcs_master_start_timeout     = $patroni::params::dcs_master_start_timeout,
  Boolean $dcs_synchronous_mode         = $patroni::params::dcs_synchronous_mode,
  Boolean $dcs_synchronous_mode_strict  = $patroni::params::dcs_synchronous_mode_strict,
  Boolean $dcs_postgresql_use_pg_rewind = $patroni::params::dcs_postgresql_use_pg_rewind,
  Boolean $dcs_postgresql_use_slots     = $patroni::params::dcs_postgresql_use_slots,
  Hash $dcs_postgresql_recovery_conf    = {},
  Hash $dcs_postgresql_parameters       = {},
  String $bootstrap_method              = $patroni::params::bootstrap_method,
  Boolean $initdb_data_checksums        = $patroni::params::initdb_data_checksums,
  String $initdb_encoding               = $patroni::params::initdb_encoding,
  String $initdb_locale                 = $patroni::params::initdb_locale,
  Array[String] $bootstrap_pg_hba       = $patroni::params::bootstrap_pg_hba,
  Array[Hash] $bootstrap_users          = [],
  String $bootstrap_post_bootstrap      = undef,
  String $bootstrap_post_init           = undef,

  # PostgreSQL Settings
  String $superuser_username           = $patroni::params::superuser_username,
  String $superuser_password           = $patroni::params::superuser_password,
  String $replication_username         = $patroni::params::replication_username,
  String $replication_password         = $patroni::params::replication_password,
  String $callback_on_reload           = undef,
  String $callback_on_restart          = undef,
  String $callback_on_role_change      = undef,
  String $callback_on_start            = undef,
  String $callback_on_stop             = undef,
  Strubg $pgsql_connect_address        = $patroni::params::pgsql_connect_address,
  Array[String] $pgsql_create_replica_methods = $patroni::params::pgsql_create_replica_methods,
  String $pgsql_data_dir               = $patroni::params::pgsql_data_dir,
  String $pgsql_config_dir             = $patroni::params::pgsql_config_dir,
  String $pgsql_bin_dir                = '',
  String $pgsql_listen                 = $patroni::params::pgsql_listen,
  Boolean $pgsql_use_unix_socket       = $patroni::params::pgsql_use_unix_socket,
  String $pgsql_pgpass_path            = $patroni::params::pgsql_pgpass_path,
  Hash $pgsql_recovery_conf            = {},
  Hash $pgsql_custom_conf              = {},
  Hash $pgsql_parameters               = {},
  Array[String] $pgsql_pg_hba          = [],
  Integer $pgsql_pg_ctl_timeout        = $patroni::params::pgsql_pg_ctl_timeout,
  Boolean $pgsql_use_pg_rewind         = $patroni::params::pgsql_use_pg_rewind,
  Boolean $pgsql_remove_data_directory_on_rewind_failure = $patroni::params::pgsql_remove_data_directory_on_rewind_failure,
  Array[Hash] $pgsql_replica_method    = {},

  # Consul Settings
  Boolean $use_consul    = $patroni::params::use_consul,
  String $consul_host    = $patroni::params::consul_host,
  String $consul_url     = undef,
  Integer $consul_port   = $patroni::params::consul_port,
  Enum['http','https'] $consul_scheme = $patroni::params::consul_scheme,
  String $consul_token   = undef,
  Boolean $consul_verify = undef,
  String $consul_cacert  = undef,
  String $consul_cert    = undef,
  String $consul_key     = undef,
  String $consul_dc      = undef,
  String $consul_checks  = undef,

  # Etcd Settings
  Boolean $use_etcd      = $patroni::params::use_etcd,
  String $etcd_host      = $patroni::params::etcd_host,
  Array[String] $etcd_endpoints = [],
  String $etcd_url       = undef,
  String $etcd_proxyurl  = undef,
  String $etcd_srv       = undef,
  Enum['http','https'] $etcd_protocol = $patroni::params::etcd_protocol,
  String $etcd_username  = undef,
  String $etcd_password  = undef,
  String $etcd_cacert    = undef,
  String $etcd_cert      = undef,
  String $etcd_key       = undef,

  # Exhibitor Settings
  Boolena $use_exhibitor           = $patroni::params::use_exhibitor,
  Array[String] $exhibitor_hosts   = [],
  Integer $exhibitor_poll_interval = $patroni::params::exhibitor_poll_interval,
  Integer $exhibitor_port          = $patroni::params::exhibitor_port,

  # Kubernetes Settings
  Boolean $use_kubernetes           = $patroni::params::use_kubernetes,
  String $kubernetes_namespace      = $patroni::params::kubernetes_namespace,
  Hash $kubernetes_labels           = {},
  String $kubernetes_scope_label    = undef,
  String $kubernetes_role_label     = undef,
  Boolean $kubernetes_use_endpoints = $patroni::params::kubernetes_use_endpoints,
  String $kubernetes_pod_ip         = undef,
  String $kubernetes_ports          = undef,

  # REST API Settings
  String $restapi_connect_address = $patroni::params::restapi_connect_address,
  String $restapi_listen          = $patroni::params::restapi_listen,
  String $restapi_username        = undef,
  String $restapi_password        = undef,
  String $restapi_certfile        = undef,
  String $restapi_keyfile         = undef,

  # ZooKeeper Settings
  Boolean $use_zookeeper         = $patorni::params::use_zookeeper,
  Array[String] $zookeeper_hosts = [],

  # Watchdog Settings
  Enum['off','automatic','required'] $watchdog_mode = $patroni::params::watchdog_mode,
  String $watchdog_device         = $patroni::params::watchdog_device,
  Integer $watchdog_safety_margin = $patroni::params::watchdog_safety_margin,

  # Module Specific Settings
  String $servicename     = $patroni::params::servicename,
  String $packagename     = $patroni::params::packagename,
  String $config_path     = $patroni::params::config_path,
  String $config_owner    = $patroni::params::config_owner,
  String $config_group    = $patroni::params::config_group,
  String $config_mode     = $patroni::params::config_mode,
  Boolean $ensure_package = $patroni::params::ensure_package,
  Boolean $ensure_service = $patroni::params::ensure_service,
  Boolean $enable_service = $patroni::params::enable_service,

) inherits patroni::params {
  anchor{'patroni::begin':}
  -> class{'::patroni::install':}
  -> class{'::patroni::config':}
  ~> class{'::patroni::service':}
  -> anchor{'patroni::end':}
}

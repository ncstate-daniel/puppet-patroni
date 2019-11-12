# Sets up and configures a Patroni instance
class patroni (

  # Global Settings
  String $scope,
  String $namespace = $patroni::params::namespace,
  String $hostname  = $::hostname,

  # Bootstrap Settings
  Integer $dcs_loop_wait                = $patroni::params::dcs_loop_wait,
  Integer $dcs_ttl                      = $patroni::params::dcs_ttl,
  Integer $dcs_retry_timeout            = $patroni::params::dcs_retry_timeout,
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
  Variant[Undef,String] $bootstrap_post_bootstrap      = undef,
  Variant[Undef,String] $bootstrap_post_init           = undef,

  # PostgreSQL Settings
  String $superuser_username           = $patroni::params::superuser_username,
  String $superuser_password           = $patroni::params::superuser_password,
  String $replication_username         = $patroni::params::replication_username,
  String $replication_password         = $patroni::params::replication_password,
  Variant[Undef,String] $callback_on_reload           = undef,
  Variant[Undef,String] $callback_on_restart          = undef,
  Variant[Undef,String] $callback_on_role_change      = undef,
  Variant[Undef,String] $callback_on_start            = undef,
  Variant[Undef,String] $callback_on_stop             = undef,
  String $pgsql_connect_address        = $patroni::params::pgsql_connect_address,
  Array[String] $pgsql_create_replica_methods = $patroni::params::pgsql_create_replica_methods,
  String $pgsql_data_dir               = $patroni::params::pgsql_data_dir,
  Variant[Undef,String] $pgsql_config_dir             = undef,
  Variant[Undef,String] $pgsql_bin_dir                = '',
  String $pgsql_listen                 = $patroni::params::pgsql_listen,
  Boolean $pgsql_use_unix_socket       = $patroni::params::pgsql_use_unix_socket,
  String $pgsql_pgpass_path            = $patroni::params::pgsql_pgpass_path,
  Hash $pgsql_recovery_conf            = {},
  Variant[Undef,String]  $pgsql_custom_conf           = undef,
  Hash $pgsql_parameters               = {},
  Array[String] $pgsql_pg_hba          = [],
  Integer $pgsql_pg_ctl_timeout        = $patroni::params::pgsql_pg_ctl_timeout,
  Boolean $pgsql_use_pg_rewind         = $patroni::params::pgsql_use_pg_rewind,
  Boolean $hiera_merge_pgsql_parameters = $patroni::params::hiera_merge_pgsql_parameters,
  Boolean $pgsql_remove_data_directory_on_rewind_failure = $patroni::params::pgsql_remove_data_directory_on_rewind_failure,
  Array[Hash] $pgsql_replica_method    = [],

  # Consul Settings
  Boolean $use_consul    = $patroni::params::use_consul,
  String $consul_host    = $patroni::params::consul_host,
  Variant[Undef,String] $consul_url     = undef,
  Integer $consul_port   = $patroni::params::consul_port,
  Enum['http','https'] $consul_scheme = $patroni::params::consul_scheme,
  Variant[Undef,String] $consul_token   = undef,
  Boolean $consul_verify = $patroni::params::consul_verify,
  Optional[Boolean] $consul_register_service = undef,
  Variant[Undef,String] $consul_cacert  = undef,
  Variant[Undef,String] $consul_cert    = undef,
  Variant[Undef,String] $consul_key     = undef,
  Variant[Undef,String] $consul_dc      = undef,
  Variant[Undef,String] $consul_checks  = undef,

  # Etcd Settings
  Boolean $use_etcd      = $patroni::params::use_etcd,
  String $etcd_host      = $patroni::params::etcd_host,
  Array[String] $etcd_hosts = [],
  Variant[Undef,String] $etcd_url       = undef,
  Variant[Undef,String] $etcd_proxyurl  = undef,
  Variant[Undef,String] $etcd_srv       = undef,
  Enum['http','https'] $etcd_protocol = $patroni::params::etcd_protocol,
  Variant[Undef,String] $etcd_username  = undef,
  Variant[Undef,String] $etcd_password  = undef,
  Variant[Undef,String] $etcd_cacert    = undef,
  Variant[Undef,String] $etcd_cert      = undef,
  Variant[Undef,String] $etcd_key       = undef,

  # Exhibitor Settings
  Boolean $use_exhibitor           = $patroni::params::use_exhibitor,
  Array[String] $exhibitor_hosts   = [],
  Integer $exhibitor_poll_interval = $patroni::params::exhibitor_poll_interval,
  Integer $exhibitor_port          = $patroni::params::exhibitor_port,

  # Kubernetes Settings
  Boolean $use_kubernetes           = $patroni::params::use_kubernetes,
  String $kubernetes_namespace      = $patroni::params::kubernetes_namespace,
  Hash $kubernetes_labels           = {},
  Variant[Undef,String] $kubernetes_scope_label    = undef,
  Variant[Undef,String] $kubernetes_role_label     = undef,
  Boolean $kubernetes_use_endpoints = $patroni::params::kubernetes_use_endpoints,
  Variant[Undef,String] $kubernetes_pod_ip         = undef,
  Variant[Undef,String] $kubernetes_ports          = undef,

  # REST API Settings
  String $restapi_connect_address = $patroni::params::restapi_connect_address,
  String $restapi_listen          = $patroni::params::restapi_listen,
  Variant[Undef,String] $restapi_username        = undef,
  Variant[Undef,String] $restapi_password        = undef,
  Variant[Undef,String] $restapi_certfile        = undef,
  Variant[Undef,String] $restapi_keyfile         = undef,

  # ZooKeeper Settings
  Boolean $use_zookeeper         = $patroni::params::use_zookeeper,
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
  String $ensure_package  = $patroni::params::ensure_package,
  String $ensure_service  = $patroni::params::ensure_service,
  Boolean $enable_service  = $patroni::params::enable_service,
  Boolean $restart_service = $patroni::params::restart_service,

) inherits patroni::params {

  if $hiera_merge_pgsql_parameters == true {
    $pgsql_parameters_all = lookup( { 'name'          => 'patroni::pgsql_parameters',
                                      'value_type'    => undef,
                                      'merge'         => {
                                        'strategy'   => 'deep',
                                      },
                                      'default_value' => $pgsql_parameters,
                                    })
  } else {
    $pgsql_parameters_all = $pgsql_parameters
  }

  anchor{'patroni::begin':}
  -> class{'::patroni::install':}
  -> class{'::patroni::config':}

  if $restart_service {
    Class['::patroni::config']
    ~> class{'::patroni::service':}
  }
  else {
    Class['::patroni::config']
    -> class{'::patroni::service':}
  }

  Class['::patroni::service']
  -> anchor{'patroni::end':}
}

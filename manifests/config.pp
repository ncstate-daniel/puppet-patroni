# Configure Patroni service
class patroni::config inherits patroni {
  file { $::patroni::config_path:
    ensure  => present,
    owner   => $::patroni::config_owner,
    group   => $::patroni::config_group,
    mode    => $::patroni::config_mode,
    content => template('patroni/postgresql.yml.erb'),
  }
}

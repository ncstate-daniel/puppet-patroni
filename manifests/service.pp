# Manage Patroni service
class patroni::service inherits patroni {
  service { $::patroni::servicename:
    ensure  => $::patroni::ensure_service,
    enable  => $::patroni::enable_service,
    restart => $::patroni::restart_service_command,
  }
}

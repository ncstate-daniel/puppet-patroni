# Default parameters
class patroni::params {
  $ensure_package = 'present'
  $ensure_service = 'running'
  $enable_service = true

  case $::osfamily {
    'RedHat': {
      $servicename = 'patroni'
      $packagename = 'patroni'
    }
    default: {
      fail { "This operating system family (${::osfamily}) is not supported.": }
    }
  }
}

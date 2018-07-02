# Install Patroni packages
class patroni::install inherits patroni {
  package { $::patroni::packagename:
    ensure => $::patroni::ensure_package,
  }
}

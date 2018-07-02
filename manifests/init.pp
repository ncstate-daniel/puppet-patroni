# Sets up and configures a Patroni instance
class patroni (
  $servicename    = $patroni::params::servicename,
  $packagename    = $patroni::params::packagename,
  $ensure_package = $patroni::params::ensure_package,
  $ensure_service = $patroni::params::ensure_service,
  $enable_service = $patroni::params::enable_service,
) inherits patroni::params {
  validate_string($servicename)
  validate_string($packagename)
  validate_string($ensure_package)
  validate_string($ensure_service)
  validate_bool($enable_service)

  anchor{'patroni::begin':}
  -> class{'::patroni::install':}
  -> class{'::patroni::config':}
  ~> class{'::patroni::service':}
  -> anchor{'patroni::end':}
}

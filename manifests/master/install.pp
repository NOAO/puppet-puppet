class puppet::master::install {
  include puppet::params

  if "$puppet::params::puppet_master_package_name" {
    package { $puppet::params::puppet_master_package_name:
      ensure => present,
    } 
  }
}

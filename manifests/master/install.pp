class puppet::master::install inherits puppet::params {

  if $puppet_master_package_name {
    package { $puppet_master_package_name:
      ensure => present,
    }
  }
}

class puppet::master::install {

  if $::puppet::master::puppet_master_package_name {
    package { $p::puppet::master::uppet_master_package_name:
      ensure => present,
    }
  }
}

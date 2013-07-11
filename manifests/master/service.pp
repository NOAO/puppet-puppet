class puppet::master::service inherits puppet::params {

  service { $puppet_master_service_name:
    enable      => true,
    ensure      => running,
    hasrestart  => true,
    hasstatus   => true,
    require     => Class['puppet::master::config'],
    subscribe   => Class['puppet::master::config'],
  }
}

class puppet::master::service {
  include puppet::params

  service { $puppet::params::puppet_master_service_name:
    enable      => true,
    ensure      => running,
    hasrestart  => true,
    hasstatus   => true,
    require     => Class['puppet::master::config'],
    subscribe   => Class['puppet::master::config'],
  }
}

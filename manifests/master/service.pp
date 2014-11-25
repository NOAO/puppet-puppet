class puppet::master::service {

  service { $::puppet::master::puppet_master_service_name:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Class['puppet::master::config'],
    subscribe  => Class['puppet::master::config'],
  }
}

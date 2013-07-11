class puppet::agent::service inherits puppet::params {

  service { $puppet_agent_service_name:
    enable      => true,
    ensure      => running,
    hasrestart  => true,
    hasstatus   => true,
    require     => Class['puppet::agent::config'],
    subscribe   => Class['puppet::agent::config'],
  }
}

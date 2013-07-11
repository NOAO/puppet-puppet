class puppet::agent::service {
  include puppet::params

  service { $puppet::params::puppet_agent_service_name:
    enable      => true,
    ensure      => running,
    hasrestart  => true,
    hasstatus   => true,
    require     => Class['puppet::agent::config'],
    subscribe   => Class['puppet::agent::config'],
  }
}

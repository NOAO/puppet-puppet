class puppet::agent::service {

  service { $puppet::agent::puppet_agent_service_name:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => Class['puppet::agent::config'],
  }
}

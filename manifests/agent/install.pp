class puppet::agent::install {

  package { $::puppet::agent::puppet_agent_package_name:
    ensure => present,
  }
}

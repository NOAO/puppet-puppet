class puppet::agent::install inherits puppet::params {

  package { $puppet_agent_package_name:
    ensure => present,
  } 
}

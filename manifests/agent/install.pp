class puppet::agent::install {
  include puppet::params

  package { $puppet::params::puppet_agent_package_name:
    ensure => present,
  } 
}

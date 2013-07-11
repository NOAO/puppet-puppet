class puppet::agent {
  include puppet::agent::install, puppet::agent::service, puppet::agent::config
}

class puppet::master {
  include puppet::master::install, puppet::master::config
}

class puppet::agent::install {
  include puppet::params

  package { $puppet::params::puppet_agent_package_name:
    ensure => present,
  } 
}

class puppet::master::install {
  include puppet::params

  if "$puppet::params::puppet_master_package_name" {
    package { $puppet::params::puppet_master_package_name:
      ensure => present,
    } 
  }
}

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

class puppet::agent::config {
  $require = Class['puppet::agent::install']

  # 0.25 does not support elsif so we're just doing this test 3 times
  if versioncmp('2.6.0', $puppetversion) > 0 {
    $confver = '0.25'
  } else {
    if versioncmp('2.7.0', $puppetversion) > 0 {
      $confver = '2.6'
    } else {
      $confver = '2.7'
    }
  }

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  concat::fragment{ 'agent':
    target  => $::puppet::params::puppet_conf_file,
    content => template("puppet/puppet.conf.erb"),
    order   => 1,
  }
  file { '/etc/puppet/auth.conf':
    ensure  => present,
    source  => "puppet:///modules/puppet/$confver/auth.conf",
  }
  if $confver == '2.6' {
    # 2.6 seems to need this file to exist, even if it's empty
    file { '/etc/puppet/namespaceauth.conf':
      ensure  => present,
    }
  }
  if $confver == '2.7' {
    # 2.6 seems to need this file to exist, even if it's empty
    file { '/etc/puppet/namespaceauth.conf':
      ensure  => present,
    source  => "puppet:///modules/puppet/$confver/namespaceauth.conf",
    }
  }

  cron { puppet_sweep_clientbucket:
    # el5.x does not have /bin/find
    command => "/usr/bin/ionice -c3 /usr/bin/find /var/lib/puppet/clientbucket -type f -mtime 365 -delete",
    user    => root,
    hour    => "12",
    minute  => fqdn_rand(59),
  }
}

class puppet::master::config {
  concat::fragment{ 'master':
    target  => $::puppet::params::puppet_conf_file,
    content => template("puppet/master.conf.erb"),
    order   => 2,
  }
}

class puppet::params {
  $puppet_conf_file = '/etc/puppet/puppet.conf'

   concat{$puppet_conf_file:
      owner => root,
      group => root,
      mode  => 0644,
   }

  case $operatingsystem {
    'redhat', 'centos', 'scientific': {
#      case $lsbmajdistrelease {
#        4,5,6: {
          $puppet_agent_package_name = ['puppet', 'facter']
          $puppet_master_package_name = 'puppet-server'
          $puppet_agent_service_name = 'puppet'
          $puppet_master_service_name = 'puppetmaster'
#        }
#      }
    }
    'gentoo': {
      $puppet_agent_package_name = ['app-admin/puppet', 'dev-ruby/facter', 'dev-ruby/ruby-augeas']
      $puppet_master_package_name = 'app-admin/puppet'
      $puppet_agent_service_name = 'puppet'
      $puppet_master_service_name = 'puppetmaster'
    }
  }
}

class puppet::agent::config inherits puppet::params {
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
    target  => $puppet_conf_file,
    content => template('puppet/puppet.conf.erb'),
    order   => 1,
  }
  file { '/etc/puppet/auth.conf':
    ensure  => present,
    source  => "puppet:///modules/puppet/${confver}/auth.conf",
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
      source  => "puppet:///modules/puppet/${confver}/namespaceauth.conf",
    }
  }

  cron { 'puppet_sweep_clientbucket':
    # el5.x does not have /bin/find
    command => '/usr/bin/ionice -c3 /usr/bin/find /var/lib/puppet/clientbucket -type f -mtime 365 -delete',
    user    => root,
    hour    => '12',
    minute  => fqdn_rand(59),
  }
}

class puppet::master::config {
  concat::fragment{ 'master':
    target  => $::puppet::params::puppet_conf_file,
    content => template("puppet/master.conf.erb"),
    order   => 2,
  }
}

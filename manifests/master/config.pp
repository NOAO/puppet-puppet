class puppet::master::config inherits puppet::params {
  concat::fragment{ 'master':
    target  => $puppet_conf_file,
    content => template("puppet/master.conf.erb"),
    order   => 2,
  }
}

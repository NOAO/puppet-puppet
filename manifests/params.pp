class puppet::params {
  $puppet_conf_file = '/etc/puppet/puppet.conf'

  concat{ $puppet_conf_file:
    owner => root,
    group => root,
    mode  => 0644,
  }

  case $::operatingsystem {
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
      $puppet_agent_package_name = [
        'app-admin/puppet',
        'dev-ruby/facter',
        'dev-ruby/ruby-augeas'
      ]
      $puppet_master_package_name = 'app-admin/puppet'
      $puppet_agent_service_name = 'puppet'
      $puppet_master_service_name = 'puppetmaster'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}

class puppet::agent {
  include puppet::agent::install, puppet::agent::service, puppet::agent::config
}

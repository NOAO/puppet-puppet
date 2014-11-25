class puppet::master inherits puppet::params {
  class{'puppet::master::install': } ->
  class{'puppet::master::config': }
}

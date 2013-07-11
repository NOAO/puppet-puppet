class puppet::master {
  class{'puppet::master::install': } ->
  class{'puppet::master::config': }
}

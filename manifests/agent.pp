class puppet::agent {
  class{'puppet::agent::install': } ->
  class{'puppet::agent::config': } ->
  class{'puppet::agent::service': } 
}

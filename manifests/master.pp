class puppet::master {
  Class[puppet::master::install] ->
  Class[ puppet::master::config]
}

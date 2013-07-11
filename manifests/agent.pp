class puppet::agent {
  Class[puppet::agent::install] ->
  Class[puppet::agent::service] ->
  Class[puppet::agent::config]
}

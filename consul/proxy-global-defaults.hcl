kind = "proxy-defaults"
name = "global"
config {
  envoy_prometheus_bind_addr = "0.0.0.0:9001"
  local_connect_timeout_ms = 1000
  handshake_timeout_ms = 10000
  protocol = "http"
}

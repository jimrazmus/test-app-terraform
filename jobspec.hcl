job "http-echo-${workspace}" {
  datacenters = ["dc1"]
  type        = "service"

  group "http-echo-${workspace}" {
    count = 1

    task "http-echo-${workspace}" {
      config {
        image = "hashicorp/http-echo:latest"
        args  = [
          "-listen", ":$${NOMAD_PORT_http}",
          "-text", "http-echo-${workspace} says Hello World!",
        ]
      }

      driver = "docker"
      leader = "true"

      resources {
        network {
          mbits = 10
          port "http" {}
        }
      }

      service {
        check {
          type     = "http"
          path     = "/health"
          interval = "60s"
          timeout  = "2s"
        }
        check_restart {
          limit = 3
          grace = "10s"
          ignore_warnings = false
        }
        name = "http-echo-${workspace}"
        port = "http"
        tags = [
          "${workspace}",
          "urlprefix-/http-echo",
        ]
      }

    }

  }

  update {
    max_parallel      = 1
    health_check      = "checks"
    min_healthy_time  = "10s"
    healthy_deadline  = "5m"
    progress_deadline = "10m"
    auto_revert       = true
    canary            = 1
    stagger           = "30s"
  }

}

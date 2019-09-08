resource "nomad_job" "http-echo" {
  jobspec = templatefile("${path.module}/jobspec.hcl", { workspace = "${terraform.workspace}" })
}
terraform {
  backend consul {
    path = "service/jimrazmus/test-app-terraform"
    gzip = true
  }
}

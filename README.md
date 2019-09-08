# test-app-terraform

Proof of concept to deploy a micro-service using Terraform.

## Getting Started

### Install the software

```
brew install consul nomad terraform vault
```

### Start the server processes

```
consul agent -dev
vault server -dev
nomad agent -dev
```

### Initialize the Terraform State

```
terraform init -backend-config path="service/jimrazmus/test-app-terraform"
```

## Review the Web Interfaces

consul: http://127.0.0.1:8500/

nomad: http://127.0.0.1:4646/

## Micro-service Life Cycle

Let's create a few deployments, destroy one, and validate another. In each case, take a peek at the Consul and Nomad interfaces to see the updates occurring. Note, you may need to refresh the browser to get up to date information.

### Deploy the 'default'

Obtain and evaluate what Terraform intends to do.

```
terraform plan
```

If it all looks right, deploy it.

```
terraform apply
```

### Deploy development and test copies

```
terraform workspace new development
terraform plan
terraform apply

terraform workspace new test
terraform plan
terraform apply
```

### Destroy the 'development' copy

```
terraform workspace select development
terraform destroy
```

### Verify the 'default' copy

```
terraform workspace select default
terraform plan
```

# test-app-terraform

Proof of concept to deploy a micro-service using Terraform. The micro-service will run as a Nomad job with state and service information kept in Consul. Consul, Nomad, and Vault run in development mode on your Mac laptop.

## Getting Started

### Install the software

Use the [Homebrew](https://brew.sh/) package manager to install the necessary software on your Mac.

```
brew install consul nomad terraform vault
```

### Start the server processes

Run each of these commands, in order, and in separate terminals. Leave them running until you are done playing.

```
consul agent -dev
vault server -dev
nomad agent -dev
```

### Initialize the Terraform State

```
terraform init -backend-config path="service/jimrazmus/test-app-terraform"
```

Note that the path here matches the path in the backend.tf file.

## Review the Web Interfaces

consul: http://127.0.0.1:8500/

nomad: http://127.0.0.1:4646/

## Micro-service Life Cycle

Let's create a few deployments, destroy one, and validate another. In each case, take a peek at the Consul and Nomad interfaces to see the updates occurring. Note, you may need to refresh the browser to get up to date information.

### Deploy the 'default' job

Obtain and evaluate what Terraform intends to do.

```
terraform plan
```

If it all looks right, deploy it.

```
terraform apply
```

### Deploy development and test jobs

```
terraform workspace new development
terraform plan
terraform apply

terraform workspace new test
terraform plan
terraform apply
```

### Destroy the 'development' job

```
terraform workspace select development
terraform destroy
```

### Verify the 'default' job

```
terraform workspace select default
terraform plan
```

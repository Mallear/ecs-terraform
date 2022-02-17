# ECS Hello World

# Project configuration

## Tools versions

Tools version are managed using [asdf](asdf-vm.com):

- terraform 1.1.3
- tflint 0.33.1

## Pre-commit

[pre-commit](pre-commit.com) is used to format, lint and validate Terraform code before commit.

# Deploy

## Environment management

Environment management is made using Terraform workspaces. To deploy production infrastructure:

```bash
cd terraform
terraform workspace new prod
terraform workspace select prod
terraform apply
```

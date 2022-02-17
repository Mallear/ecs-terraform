locals {
  project     = "ecs"
  environment = terraform.workspace
  name_suffix = join("-", [local.project, local.environment])

  tags = {
    "Project"     = local.project,
    "Environment" = local.environment,
    "Region"      = "eu-west-3",
    "ManagedBy"   = "terraform",
  }
}

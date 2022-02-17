
resource "aws_ecs_capacity_provider" "prov1" {
  name = "prov1"

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.asg.autoscaling_group_arn
  }

}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.4.1"
  name    = "ecs-${local.name_suffix}"

  container_insights = false
  capacity_providers = [aws_ecs_capacity_provider.prov1.name]

  default_capacity_provider_strategy = [{
    capacity_provider = aws_ecs_capacity_provider.prov1.name
    weight            = "1"
  }]
}

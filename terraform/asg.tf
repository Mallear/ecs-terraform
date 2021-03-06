module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  name = "asg-${local.name_suffix}"

  # Launch configuration
  lc_name   = "launch-${local.name_suffix}"
  use_lc    = true
  create_lc = true

  image_id                  = data.aws_ami.amazon_linux_ecs.id
  instance_type             = "t3.medium"
  security_groups           = [module.vpc.default_security_group_id]
  iam_instance_profile_name = aws_iam_instance_profile.this.id
  user_data                 = <<EOF
  #!/bin/bash
  echo ECS_CLUSTER=ecs-${local.name_suffix} >> /etc/ecs/ecs.config
  EOF

  # Auto scaling group
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1 # we don't need them for the example
  wait_for_capacity_timeout = 0

}

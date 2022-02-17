
resource "aws_cloudwatch_log_group" "this" {
  name              = "ecs-${local.name_suffix}"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "this" {
  family = "hello-worls-${local.name_suffix}"

  container_definitions = jsonencode([
    {
      name   = "hello_world-${local.environment}"
      image  = "digitalocean/flask-helloworld:latest"
      cpu    = 1
      memory = 512
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region = "${data.aws_region.current.name}"
          awslogs-group  = "${aws_cloudwatch_log_group.this.name}"
        }
      }

    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "hello-world-svc-${local.name_suffix}"
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.this.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = aws_ecs_capacity_provider.prov1.name
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "hello_world-${local.environment}"
    container_port   = 5000
  }
}


resource "aws_security_group" "svc" {
  name        = "svc-${local.name_suffix}-sg"
  description = "Security Group for svc"
  vpc_id      = module.vpc.vpc_id
}


resource "aws_security_group_rule" "public_svc_ingress" {
  description              = "Open from LB"
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb.id
  security_group_id        = aws_security_group.svc.id
}

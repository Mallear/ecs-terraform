
resource "aws_cloudwatch_log_group" "this" {
  name              = "ecs-${local.name_suffix}"
  retention_in_days = 1
  kms_key_id        = aws_kms_key.this.id
}

resource "aws_ecs_task_definition" "this" {
  family = "hello-worls-${local.name_suffix}"

  container_definitions = <<EOF
[
  {
    "name": "hello_world-${local.environment}",
    "image": "digitalocean/flask-helloworld:latest",
    "cpu": 0,
    "memory": 128,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${data.aws_region.current.name}",
        "awslogs-group": "${aws_cloudwatch_log_group.this.name}"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "this" {
  name            = "hello-world-svc-${local.name_suffix}"
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.this.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}

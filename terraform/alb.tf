resource "aws_lb" "this" {
  name               = "alb-${substr(local.name_suffix, 0, 20)}"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.lb.id]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "this" {

  name     = "tg-${local.name_suffix}-${substr(uuid(), 0, 3)}"
  port     = "5000"
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    healthy_threshold = 3
    interval          = 15
    matcher           = "200"
    path              = "/"
  }

  # Used to manage listener rule update
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}


resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_security_group" "lb" {
  name        = "lb-${local.name_suffix}-sg"
  description = "Security Group for lb"
  vpc_id      = module.vpc.vpc_id
}


resource "aws_security_group_rule" "public_lb_ingress" {
  description       = "Open all"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_alb" "loadbalancer" {

  name            = "myproject-elb-${var.environment}"
  internal        = false
  subnets         = [for subnet in aws_subnet.public : subnet.id]
  security_groups = ["${aws_security_group.loadbalancer.id}"]

  idle_timeout               = 300
  enable_deletion_protection = false

  tags = {
    "Name"        = "${var.environment}-LoadBalancer"
    "Project"     = "MyProject"
    "Environment" = "${var.environment}"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.loadbalancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

}

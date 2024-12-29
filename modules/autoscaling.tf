resource "aws_placement_group" "test" {
  name     = var.environment
  strategy = "cluster"
}

resource "aws_launch_template" "template" {
  name_prefix          = "asg-${var.environment}"
  image_id             = var.autoscaling["ami"]
  instance_type        = var.autoscaling["instance_type"]
  security_group_names = [aws_security_group.access_to_asg.id]
}

resource "aws_autoscaling_group" "asg" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = var.autoscaling["desired_capacity"]
  max_size           = var.autoscaling["max_size"]
  min_size           = var.autoscaling["min_size"]

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg-elb" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  elb                    = aws_alb.loadbalancer.id
}  
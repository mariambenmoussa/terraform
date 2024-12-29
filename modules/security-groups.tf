resource "aws_security_group" "loadbalancer" {
  name        = "http(s)_to_loadbalancer"
  description = "give http(s) access to loadbalancer"
  vpc_id      = aws_vpc.network.id
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"        = "${var.environment}-SecurityGroup-LoadBalancer"
    "Project"     = "MyProject"
    "Environment" = "${var.environment}"
  }
}

resource "aws_security_group" "access_to_database" {
  name   = "access_to_database"
  vpc_id = aws_vpc.network.id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.loadbalancer.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name"        = "${var.environment}-SecurityGroup-Database"
    "Environment" = "${var.environment}"
  }
}

resource "aws_security_group" "access_to_database_replica" {
  name   = "access_to_database"
  vpc_id = aws_vpc.network.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ToDo: needs to be restricted 
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name"        = "${var.environment}-SecurityGroup-Database-replica"
    "Environment" = "${var.environment}"
  }
}

resource "aws_security_group" "access_to_asg" {
  name        = "http(s)_to_EC2_in_ASG"
  description = "allow only http(s) access to ASG from theloadbalancer"
  vpc_id      = aws_vpc.network.id
  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.loadbalancer.id]
  }
  ingress {
    description     = "HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.loadbalancer.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"        = "${var.environment}-SecurityGroup-autoscaling-group"
    "Environment" = "${var.environment}"
  }
}
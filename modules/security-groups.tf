resource "aws_security_group" "loadbalancer" {
    name = "http(s)_to_loadbalancer"
    description = "give http(s) access to loadbalancer"
    vpc_id = "${aws_vpc.network.id}"
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
        "Name"              = "${var.environment}-SecurityGroup-LoadBalancer"
        "Project"           = "MyProject"
        "Environment"       = "${var.environment}"
    }
}

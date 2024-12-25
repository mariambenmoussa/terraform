resource "aws_vpc" "network" {
    cidr_block              = "${var.network["cidr"]}"
    enable_dns_support      = "true"
    enable_dns_hostnames    = "true"
    instance_tenancy        = "default"  
    tags = {
        "Name"              = "${var.environment}-Network"
        "Project"           = "MyProject"
        "Environment"       = "${var.environment}"
    }
}
resource "aws_default_route_table" "route" {
    default_route_table_id = "${aws_vpc.network.default_route_table_id}"
    tags = {
        "Name"              = "${var.environment}-Route-Table-Default"
        "Project"           = "MyProject"
        "Environment"       = "${var.environment}"
    }
}

resource "aws_subnet" "public" {
    count = 3
    vpc_id                  = "${aws_vpc.network.id}"
    cidr_block              = "${lookup(var.subnets_public, count.index)}"
    availability_zone       = "${lookup(var.availability_zones, count.index)}"
    tags = {
        "Name"              = "${var.environment}-Subnet-Public.${count.index}"
        "Project"           = "MyProject"
        "Environment"       = "${var.environment}"
    }
}
resource "aws_subnet" "private" {
    count = 3
    vpc_id                  = "${aws_vpc.network.id}"
    cidr_block              = "${lookup(var.subnets_private, count.index)}"
    availability_zone       = "${lookup(var.availability_zones, count.index)}"
    tags = {
        "Name"              = "${var.environment}-Subnet-Private.${count.index}"
        "Project"           = "MyProject"
        "Environment"       = "${var.environment}"
    }
}


resource "aws_eip" "gateway_nat_ip" {
    vpc                    = true
    tags = {
        "Name"             = "${var.environment}-NAT-Gateway-IP"
        "Project"          = "MyProject"
        "Environment"      = "${var.environment}"
    }
}

resource "aws_nat_gateway" "gateway" {
    allocation_id          = "${aws_eip.gateway_nat_ip.id}" 
    subnet_id              = "${aws_subnet.public.0.id}"    
    tags = {
        "Name"             = "${var.environment}-NAT-Gateway"
        "Project"          = "MyProject"
        "Environment"      = "${var.environment}"
    }
}

resource "aws_route_table" "private" {
    vpc_id                 = "${aws_vpc.network.id}"
    tags = {
        "Name"             = "${var.environment}-Route-Table-Private"
        "Project"          = "MyProject"
        "Environment"      = "${var.environment}"
    }
}
resource "aws_route" "nat" {
    route_table_id            = "${aws_route_table.private.id}"
    nat_gateway_id            = "${aws_nat_gateway.gateway.id}"  
    destination_cidr_block    = "0.0.0.0/0"                         
}

resource "aws_route_table_association" "private" {
  count           = 3
  subnet_id       = "${element(aws_subnet.private.*.id, count.index)}"  
  route_table_id  = "${aws_route_table.private.id}"       
}

resource "aws_internet_gateway" "gateway" {
    vpc_id                 = "${aws_vpc.network.id}"
    tags = {
        "Name"             = "${var.environment}-Internet-Gateway"
        "Project"          = "MyProject"
        "Environment"      = "${var.environment}"
    }
}

resource "aws_route_table" "public" {
    vpc_id                 = "${aws_vpc.network.id}"
    route {
        gateway_id         = "${aws_internet_gateway.gateway.id}"       
        cidr_block         = "0.0.0.0/0"    
    }
    tags = {
        "Name"             = "${var.environment}-Route-Table-Public"
        "Project"          = "MyProject"
        "Environment"      = "${var.environment}"
    }
}

resource "aws_route_table_association" "public" {
    count           = 3
    subnet_id       = "${element(aws_subnet.public.*.id, count.index)}"     
    route_table_id  = "${aws_route_table.public.id}"        
}





// VPC Peering 


resource "aws_vpc_peering_connection" "env2" {
    count           = "${var.env2["peering.activated"]}"
    peer_owner_id   = "${var.env2["peering.account_id"]}"
    peer_vpc_id     = "${var.env2["peering.vpc_id"]}"
    vpc_id          = "${aws_vpc.network.id}"
    peer_region     = "eu-west-1"
    tags {
         Name               = "${var.environment}-Peering-env2"
         Project            = "MyProject"
         Environment        = "${var.environment}"
    }
}
resource "aws_route" "env2" {
    count                   = "${var.env2["peering.activated"]}"
    destination_cidr_block  = "${var.env2["peering.vpc_cidr"]}"
    route_table_id          = "${aws_vpc.network.main_route_table_id}"
    gateway_id              = "${aws_vpc_peering_connection.env2.id}"
}


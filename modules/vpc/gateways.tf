# NAT Gateway(IGW)
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.infra-env}-igw"
    Project     = "walkthrough"
    Environment = var.infra-env
    VPC         = aws_vpc.vpc.id
    ManagedBy   = "terraform"
  }

  # lifecycle {
  #   create_before_destroy = true
  # }
}

# Internet Gateway(IGW)
# resource "aws_eip" "eip-nat" {

#   count  = (var.create-eip) ? 1 : 0
#   domain = "vpc"

#   lifecycle {
#     #  prevent_destroy = true
#   }

#   tags = {
#     Name        = "${var.infra-env}-eip"
#     Project     = "walkthrough"
#     VPC         = aws_vpc.vpc.id
#     Environment = var.infra-env
#     ManagedBy   = "terraform"
#   }
# }


# locals {
#   cidr = toset([
#     "10.0.2.0/24",
#     "10.0.4.0/24",
#   ])

#   pub-cidr = toset([
#     "10.0.1.0/24",
#   ])

#   azs = toset([
#     "us-east-2a",
#     "us-east-2b",
#   ])
# }

# Public Route Tables (Subnets with NGW)
resource "aws_subnet" "public" {
  for_each                = var.public-subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.infra-env}-public-subnet-${each.key}"
    Project     = "walkthrough"
    Role        = "public"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    # Subnet      = "${each.value.cidr}"
    Tier = "web-tier"
  }

}

# This can be used to access the internet witout using nat gateway
resource "aws_vpc_endpoint" "endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.us-east-2.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.private-route-table.id
  ]
}


# Private subnet for app tier (Subnets with NGW)
resource "aws_subnet" "private" {

  for_each = var.private-subnets

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.infra-env}-private-subnet-${each.key}"
    Project     = "walkthrough"
    Role        = "private"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    # Subnet      = each.value
    Tier = "app-tier"
  }
}

# Private subnet for db tier (Subnets with NGW)
# resource "aws_subnet" "mongodb" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.db-subnet
#   availability_zone       = 
#   map_public_ip_on_launch = false

#   tags = {
#     Name        = "${var.infra-env}-db-subnet"
#     Project     = "walkthrough"
#     Role        = "db"
#     Environment = var.infra-env
#     ManagedBy   = "terraform"
#     Subnet      = var.db-subnet
#   }
# }



# NAT Gateway(IGW)
# resource "aws_nat_gateway" "nat-gateway" {

#   allocation_id     = (var.create-eip) ? aws_eip.eip-nat[0].id : ""
#   connectivity_type = (var.create-eip) ? "public" : "private"

#   subnet_id = aws_subnet.public[element(keys(aws_subnet.public), 0)].id
#   tags = {
#     Name        = "${var.infra-env}-ngw"
#     Project     = "walkthrough"
#     VPC         = aws_vpc.vpc.id
#     Environment = var.infra-env
#     ManagedBy   = "terraform"
#   }

# depends_on = [aws_internet_gateway.internet-gateway]

# lifecycle {
#   create_before_destroy = true
# }
# }


# Public Route
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.infra-env}-public-route-table"
    Project     = "walkthrough"
    Environment = var.infra-env
    ManagedBy   = "terraform"
  }

}


# Private Route
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.infra-env}-private-route-table"
    Project     = "walkthrough"
    Environment = var.infra-env
    ManagedBy   = "terraform"
  }

}


# resource "aws_route_table" "db-route-table" {
#   vpc_id = aws_vpc.vpc.id
#   tags = {
#     Name        = "${var.infra-env}-db-route-table"
#     Project     = "walkthrough"
#     Environment = var.infra-env
#     ManagedBy   = "terraform"
#   }
#   route {
#     cidr_block = aws_vpc.vpc.cidr_block
#     gateway_id = "local"
#   }
# }

resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.internet-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

# resource "aws_route" "private-route" {
#   route_table_id         = aws_route_table.private-route-table.id
#   # nat_gateway_id         = aws_nat_gateway.nat-gateway.id
#   destination_cidr_block = "0.0.0.0/0"
# }

# resource "aws_route" "db-route" {
#   route_table_id = aws_route_table.db-route-table
#   gateway_id     = "local"
# }

# Public Route to Public Route Table for Public Subnet
resource "aws_route_table_association" "public-subnet-route-table-association" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public-route-table.id

}

# Private Route to Private Route Table for Private Subnet
resource "aws_route_table_association" "private-route-table-association" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private-route-table.id

}


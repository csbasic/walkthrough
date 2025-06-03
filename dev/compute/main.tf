data "aws_ami" "runner-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu-pro-server/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-pro-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"]
}

data "aws_vpc" "vpc" {
  tags = {
    Name        = "walkthrough-${var.infra-env}-vpc"
    Project     = "walkthrough"
    Environment = var.infra-env
    ManagedBy   = "terraform"
  }
}

data "aws_security_group" "public-sg" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:Name"
    values = ["${var.project-name}-${var.infra-env}-public-sg"]
  }

  tags = {
    Name        = "${var.project-name}-${var.infra-env}-public-sg"
    Project     = "walkthrough"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    Role        = "public"
  }
}

data "aws_security_group" "private-sg" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:Name"
    values = ["${var.project-name}-${var.infra-env}-private-sg"]
  }

  tags = {
    Name        = "${var.project-name}-${var.infra-env}-private-sg"
    Project     = "walkthrough"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    Role        = "private"
  }
}


# data "aws_subnets" "filtered_subnets" {

#   filter {
#     name   = "tag:Name"
#     values = ["${var.infra-env}-public-subnet-${var.azs[0]}"]
#   }


#   tags = {
#     Name        = "${var.infra-env}-public-subnet-${var.azs[0]}"
#     Project     = "walkthrough"
#     Role        = "public"
#     Environment = var.infra-env
#     ManagedBy   = "terraform"
#     Subnet      = var.public-subnets[0]
#     Tier        = "web-tier"
#   }

# }

data "aws_subnet" "private-subnets" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:Name"
    values = ["${var.infra-env}-private-subnet-${var.azs[0]}"]
  }

  tags = {
    Name        = "${var.infra-env}-private-subnet-${var.azs[0]}"
    Project     = "walkthrough"
    Role        = "private"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    Subnet      = var.private-subnets[0]
    Tier        = "app-tier"
  }
}

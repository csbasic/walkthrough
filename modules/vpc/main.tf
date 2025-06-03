resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "walkthrough-${var.infra-env}-vpc"
    Project     = "walkthrough"
    Environment = var.infra-env
    ManagedBy   = "terraform"
  }
  # lifecycle {
  #   create_before_destroy = true
  # }
}

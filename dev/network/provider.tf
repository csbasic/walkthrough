terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  # required_version = ">= 1.5.0"
  backend "s3" {
    region = "us-east-2"
  }
}

provider "aws" {
  region = var.aws-region
  # profile = "stellatech" # This is the profile name in the ~/.aws/credentials file
}

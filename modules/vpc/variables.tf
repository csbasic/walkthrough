variable "region" {
  description = "aws region"
  type        = string
}

variable "vpc-cidr" {
  type        = string
  description = "The IP range to user for the VPC"
  default     = "10.0.0.0/16"
}

variable "project-name" {
  description = "name of the project"
  type        = string
}

variable "infra-env" {
  description = "Infrastructure environment"
  type        = string
}

variable "public-subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    "subnet-1pu" = { cidr_block = "10.0.1.0/24", availability_zone = "us-east-2a" }
    # "subnet-2" = { cidr_block = "10.0.5.0/24", availability_zone = "us-east-2b" }
    # "subnet-a3" = { cidr_block = "10.0.4.0/24", availability_zone = "us-east-1c" }
  }
}


variable "private-subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    "subnet-1pr" = { cidr_block = "10.0.2.0/24", availability_zone = "us-east-2a" }
    # "subnet-a2" = { cidr_block = "10.0.4.0/24", availability_zone = "us-east-2b" }
    # "subnet-a3" = { cidr_block = "10.0.4.0/24", availability_zone = "us-east-1c" }
  }
}

variable "create-eip" {
  type        = bool
  description = "Whether to create an EIP for the ec2 instance or not"
  default     = false
}

variable "app-ports" {
  type = list(number)
  # default = [22, 80, 443, 8080, 27017, 465, 25, 9000]
  default = [22, 80, 443, 9000]
}

variable "db-ports" {
  type = list(number)
  # default = [22, 80, 443, 8080, 27017, 465, 25, 9000]
  default = [27017, 3306]
}


variable "ports-role" {
  type = list(string)
  # default = ["ssh", "http", "https", "http-1", "mongodb", "gmail", "servers-servers-2", "docker", ]
  default = ["ssh", "http", "https", "http-1", "mongodb", "gmail", "servers-servers-2", "docker", ]
}

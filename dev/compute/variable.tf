variable "aws-region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}


variable "instance-type" {
  description = "instance type for EC2"
  type        = string
  default     = "t2.medium"
}


variable "infra-role" {
  type        = string
  description = "to run GitHub-Runner, Docker, Trivy"
  default     = "CI pipeline"
}

variable "infra-env" {
  type        = string
  description = "infrastructure environment"
  default     = "dev"
}

variable "ami-id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2
}

variable "project-name" {
  description = "name of the project"
  type        = string
  default     = "walkthrough"
}

variable "user-data" {
  description = "user data script to initialize the instance"
  type        = string
  default     = <<-EOT
    #!/bin/bash
    sudo yum update -y
    EOT
}

variable "volume-size" {
  default = 32
}

variable "volume-type" {
  default = "gp3"
}

variable "module-instance-name" {
  type        = string
  description = "name given to intance when module is called"
  default     = "ubuntu"
}


variable "cluster-name" {
  type    = string
  default = "walkthrough-eks"
}

variable "public-subnets" {
  default = ["10.0.1.0/24"]
}

variable "private-subnets" {
  default = ["10.0.2.0/24"]
}

variable "db-subnet" {
  default = "10.0.3.0/24"
}

variable "azs" {
  default = ["us-east-2a"]
}


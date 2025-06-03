
variable "instance-type" {
  description = "Instance type for EC2"
  type        = string
}

variable "instance-name" {
  type        = string
  description = "Name of intance"
}

variable "volume-type" {
  type        = string
  description = "Name of intance"
}

variable "volume-size" {
  type        = string
  description = "Name of intance"
}

variable "infra-role" {
  description = "Infrastructure role"
  type        = string
}

variable "user-data" {
  description = "User data script to initialize the instance"
  type        = string
  default     = <<-EOT
    #!/bin/bash
    sudo yum update -y
    EOT
}

variable "infra-env" {
  type        = string
  description = "Infrastructure environment"
}


variable "subnets" {
  type        = list(string)
  description = "Valid subnets to assign to server"
}

variable "security-groups-ids" {
  description = "Security groupes to assign to server"
}


variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for ec2 intance"
}

variable "ami-id" {
  type        = string
  description = "amazone machine image ID for Ubuntu Pro Server 24.04 - provider : canonical"
}

variable "subnet-id" {
  type        = string
  description = "Subnet ID of either web:app:db subnets for marketup"
}

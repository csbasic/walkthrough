resource "aws_instance" "marketup-runner" {
  ami             = var.ami-id
  instance_type   = var.instance-type
  key_name        = "marketup-key"
  subnet_id       = var.subnet-id
  security_groups = var.security-groups-ids

  root_block_device {
    volume_size = var.volume-size # GB
    volume_type = var.volume-type
  }

  associate_public_ip_address = true

  # subnet_id = random_shuffle.subnets.result[0]

  tags = {
    Name        = "marketup-${var.infra-env}-${var.instance-name}"
    Project     = "marketup"
    Role        = "${var.infra-role}"
    Environment = "${var.infra-env}"
    ManagedBy   = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }

}

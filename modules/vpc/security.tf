

###
# Public Security group
##
resource "aws_security_group" "public-sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "walkthrough-${var.infra-env}-public-sg"
  description = "Allow TLS inbound traffic"

  tags = {
    Name        = "${var.project-name}-${var.infra-env}-public-sg"
    Project     = "walkthrough"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    Role        = "public"
  }

  # lifecycle {
  #   create_before_destroy = true
  # }
}

resource "aws_security_group_rule" "public-out" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public-sg.id
}


resource "aws_security_group_rule" "public-in" {
  type              = "ingress"
  count             = length(var.app-ports)
  description       = "inbound rules for public traffic"
  from_port         = var.app-ports[count.index]
  to_port           = var.app-ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Allow traffic from all IPs
  security_group_id = aws_security_group.public-sg.id
}


###
# App Security group
##

resource "aws_security_group" "private-sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "walkthrough-${var.infra-env}-private-sg"
  description = "private internet"

  tags = {
    Name        = "${var.project-name}-${var.infra-env}-private-sg"
    Project     = "walkthrough"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    Role        = "private"
  }



  # lifecycle {
  #   create_before_destroy = true
  # }
}


resource "aws_security_group_rule" "private-out" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private-sg.id
}



# Inbound rule for private network traffic
resource "aws_security_group_rule" "private-in" {

  type  = "ingress"
  count = length(var.app-ports)

  description       = "Allow specific traffic within the private network"
  from_port         = var.app-ports[count.index]
  to_port           = var.app-ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Allow traffic from all IPs
  security_group_id = aws_security_group.private-sg.id
}


###
# DB Security group
##

resource "aws_security_group" "db-sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "walkthrough-${var.infra-env}-mongodb-sg"
  description = "Allow MongoDB access"

  tags = {
    Name        = "${var.project-name}-${var.infra-env}-db-sg"
    Project     = "walkthrough"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    Role        = "secure connect app - db"
  }

  # lifecycle {
  #   create_before_destroy = true
  # }
}


# Allow app to connnect to db on the private subnet
resource "aws_security_group_rule" "allow-app-to-db" {
  type                     = "ingress"
  from_port                = var.db-ports[0] # Example for MySQL
  to_port                  = var.db-ports[0]
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db-sg.id
  source_security_group_id = aws_security_group.private-sg.id
}

# Egress Rule - Allow DB to communicate to the private subnet or elsewhere
resource "aws_security_group_rule" "allow-db-to-private-egress" {
  # for_each          = toset(var.private-subnets)
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # All traffic (or can specify a protocol)
  cidr_blocks       = ["0.0.0.0/0"] #[each.value] # Adjust this to your private subnet CIDR block
  security_group_id = aws_security_group.db-sg.id

}

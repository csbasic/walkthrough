
output "vpc-id" {
  value = aws_vpc.vpc.id
  #   value = aws_vpc.this.id
}

# output "public-subnets" {
#   # value = aws_subnet.public.*.id
#   value = [for subnet in aws_subnet.public : subnet.id]
# }

# output "private-subnets" {
#   value = values(aws_subnet.private).id
# }


output "public-sg" {
  value = aws_security_group.public-sg.id
}

output "private-sg" {
  value = aws_security_group.private-sg.id
}

output "db-sg" {
  value = aws_security_group.db-sg.id
}

# output "private-subnets" {
#   value = aws_subnet.private[].id
# }


output "private-subnets" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "public-subnets" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

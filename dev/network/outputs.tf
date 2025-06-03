output "vpc-id" {
  value = module.vpc.vpc-id
}

output "public-sg" {
  value = module.vpc.public-sg
}

output "private-sg" {
  value = module.vpc.private-sg
}

output "db-sg" {
  value = module.vpc.db-sg
}

output "private-subnets" {
  value = module.vpc.private-subnets
}

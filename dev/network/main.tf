
module "vpc" {
  source       = "../../modules/vpc"
  region       = var.aws-region
  infra-env    = var.infra-env
  project-name = "walkthrough"
  # public-subnets  = var.public-subnets
  # private-subnets = var.private-subnets
  # db-subnet       = var.db-subnet
  # azs             = var.azs
  create-eip = false

}

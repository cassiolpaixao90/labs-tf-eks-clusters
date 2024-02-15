locals {
  aws_region       = "us-east-1"
  environment_name = "staging"
  tags             = {
    ops_env              = local.environment_name
    ops_managed_by       = "terraform",
    ops_source_repo      = "labs-tf-eks-clusters",
    ops_source_repo_path = "envs/${local.environment_name}/vpc",
    ops_owners           = "devops",
  }
}

####################################################################################
# VPC
####################################################################################
module "vpc" {
  source           = "../../infra/modules/vpc"
  aws_region       = local.aws_region
  azs              = ["us-east-1a", "us-east-1c"]
  vpc_cidr         = "10.0.0.0/16"
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"]
  environment_name = local.environment_name
  cluster_name     = local.environment_name
  tags             = local.tags
}

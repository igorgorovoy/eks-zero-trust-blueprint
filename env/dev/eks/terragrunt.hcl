include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../infrastructure/eks"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id            = "vpc-00000000"
    private_subnet_ids = ["subnet-00000000", "subnet-11111111", "subnet-22222222"]
  }
}

inputs = {
  vpc_id             = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
} 
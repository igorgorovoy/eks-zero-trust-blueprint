include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../infrastructure/vpc"
}

dependencies {
  paths = []
}

inputs = {} 
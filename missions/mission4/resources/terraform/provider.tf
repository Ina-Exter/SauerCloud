#Provider, always AWS
provider "aws" {
  profile = var.profile
  region  = var.region
  version = "~> 2.31"
}

terraform {
  required_version = "<=0.12.19"
}

#Provider, always AWS
provider "aws" {
	profile = var.profile
	region = var.region
	version = "~> 2.31"
}

provider "archive" {
	version = "~> 1.3"
}

provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket         = "tech-challenge-tf-state-bucket"
    key            = "gateway/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "tech-challenge-tf-state-bucket"
    key    = "api/terraform.tfstate"
    region = "us-west-2"
  }
}
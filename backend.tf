terraform {
  backend "s3" {
    bucket = "terra-state-main"
    key    = "terraform-demo/backend"
    region = "us-east-1"
  }
}
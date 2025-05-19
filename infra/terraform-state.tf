terraform {
  backend "s3" {
    bucket  = "alismed-terraform"
    key     = "books-api/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

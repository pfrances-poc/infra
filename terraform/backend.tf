terraform {
  backend "s3" {
    bucket         = "greetings-tf-state-bucket-dev"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    profile        = "greetings"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}


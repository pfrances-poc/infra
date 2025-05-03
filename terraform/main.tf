data "aws_s3_bucket" "tf_state_bucket" {
  bucket = "greetings-tf-state-bucket-dev"
}

data "aws_dynamodb_table" "tf_lock_table" {
  name = "terraform-locks"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "${var.project_name}-${var.environment}-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = true

}

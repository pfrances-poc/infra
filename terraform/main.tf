data "aws_s3_bucket" "tf_state_bucket" {
  bucket = "greetings-tf-state-bucket-dev"
}

data "aws_dynamodb_table" "tf_lock_table" {
  name = "terraform-locks"
}
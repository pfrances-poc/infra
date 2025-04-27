output "bucket_name" {
  value = data.aws_s3_bucket.tf_state_bucket.bucket
}

output "dynamodb_table_name" {
  value = data.aws_dynamodb_table.tf_lock_table.name
}

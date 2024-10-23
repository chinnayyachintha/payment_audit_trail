output "dynamodb_table_name" {
  value = aws_dynamodb_table.payment_audit_trail.name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.dynamodb_backup.bucket
}

output "sqs_queue_url" {
  value = aws_sqs_queue.audit_trail_queue.url
}

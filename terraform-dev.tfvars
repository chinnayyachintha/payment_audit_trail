aws_region = "ca-central-1"

dynamodb_table_name = "payment-audit-trail"

s3_bucket_name = "payment-audit-trail"

sqs_queue = "payment-audit-trail.fifo"

iam_role = "lambda_execution_role_audit_logs"

lambda_function = "audit_trail_processor"

tags = {
  Environment = "Development",
  Project     = "Payment Gateway",
  Owner       = "Anudeep"
}

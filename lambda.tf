resource "aws_lambda_function" "audit_trail_processor" {
  filename         = "lambda/deployment.zip"
  function_name    = "${var.lambda_function}"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.payment_audit_trail.name
      S3_BUCKET      = aws_s3_bucket.dynamodb_backup.bucket
      SQS_QUEUE_URL  = aws_sqs_queue.audit_trail_queue.url
    }
  }

  tags = merge(
    {
      Name = var.lambda_function
    },
    var.tags 
}

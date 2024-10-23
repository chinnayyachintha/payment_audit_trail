variable "aws_region" {
  type        = string
  description = "Name of the specific region"
}

variable "dynamodb_table_name" {
  type        = string
  description = "Name of the Dynamodb Table and S3 Bucket name"
}

variable "iam_role" {
  type        = string
  description = "Specifying role name"
}

variable "s3_bucket_name" {
  type        = string
  description = "Specifying 3_bucket_name"
}

variable "lambda_function" {
  type        = string
  description = "Name of the lambda function"
}

variable "sqs_queue" {
  type        = string
  description = "Name of the sqs_queue"
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
}
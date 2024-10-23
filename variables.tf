variable "aws_region" {
  type        = string
  description = "Name of the specific region"
}

variable "dynamodb_table_name" {
  type= string
  description = "Name of the Dynamodb Table and S3 Bucket name"
}

variable "iam_role" {
  type        = string
  description = "Specifying role name"
}

variable "lambda_function" {
  type =string
  description = "Name of the lambda function"
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
}
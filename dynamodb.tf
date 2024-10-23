resource "aws_dynamodb_table" "payment_audit_trail" {
  name           = "${var.dynamodb_table_name}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"
  range_key      = "timestamp"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  tags = merge(
    {
      Name = var.dynamodb_table_name
    },
    var.tags 
}

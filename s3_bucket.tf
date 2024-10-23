# Create a random ID to append to bucket names
resource "random_id" "random_hex" {
  byte_length = 8  # Generates a random 8-byte string for uniqueness
}

# S3 Bucket to store audit logs
resource "aws_s3_bucket" "dynamodb_audit_logs" {
  bucket = format("%s-%s", replace(var.dynamodb_table_name, "_", "-"), random_id.random_hex.hex)  # Format bucket name with random suffix

  # Enable versioning for audit logs
  versioning {
    enabled = true
  }

  # Enable server-side encryption using AWS-managed keys
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = "${var.dynamodb_table_name}-logs"  # Tag for the S3 bucket
  }
}

# Remove the block public access settings (allow public access)
resource "aws_s3_bucket_public_access_block" "dynamodb_audit_logs_block" {
  bucket = aws_s3_bucket.dynamodb_audit_logs.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket Policy for logging
resource "aws_s3_bucket_policy" "dynamodb_audit_logs_policy" {
  bucket = aws_s3_bucket.dynamodb_audit_logs.bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.dynamodb_audit_logs.arn}/*",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

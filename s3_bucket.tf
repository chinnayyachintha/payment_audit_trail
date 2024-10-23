# Fetch the current AWS account details
data "aws_caller_identity" "current" {}

# Create a random ID to append to bucket names
resource "random_id" "random_hex" {
  byte_length = 8 # Generates a random 8-byte string for uniqueness
}

# S3 Bucket to store backups
resource "aws_s3_bucket" "dynamodb_backup" {
  bucket = format("%s-backup-%s", replace(var.s3_bucket_name, "_", "-"), random_id.random_hex.hex) # Format bucket name with random suffix

  tags = merge(
    {
      Name = "${var.s3_bucket_name}-Bucket"
    },
    var.tags
  )
}

# Enable versioning for the S3 Bucket
resource "aws_s3_bucket_versioning" "dynamodb_backup_versioning" {
  bucket = aws_s3_bucket.dynamodb_backup.id

  # This block is required to define versioning settings
  versioning_configuration {
    enabled = true  # Set to false if you want to disable versioning
  }
}

# Server-Side Encryption Configuration for the S3 Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "dynamodb_backup_encryption" {
  bucket = aws_s3_bucket.dynamodb_backup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Use AWS-managed keys for encryption
    }
  }
}

# Remove the block public access settings (allow public access)
resource "aws_s3_bucket_public_access_block" "dynamodb_backup_block" {
  bucket = aws_s3_bucket.dynamodb_backup.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket Policy for allowing access (optional)
resource "aws_s3_bucket_policy" "dynamodb_backup_policy" {
  bucket = aws_s3_bucket.dynamodb_backup.bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.dynamodb_backup.arn}/*",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

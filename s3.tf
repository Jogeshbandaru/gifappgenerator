# Create an IAM role for Terraform
resource "aws_iam_role" "terraform_s3_role" {
  name = "terraform-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com" # Change if Terraform runs elsewhere
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach an IAM policy to the role to allow S3 operations
resource "aws_iam_policy" "terraform_s3_policy" {
  name        = "terraform-s3-policy"
  description = "Allows Terraform to manage S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:HeadBucket",
          "s3:GetBucketAcl",
          "s3:GetBucketEncryption",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::secure-app-bucket-unique12345",
          "arn:aws:s3:::secure-app-bucket-unique12345/*"
        ]
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "terraform_s3_policy_attach" {
  role       = aws_iam_role.terraform_s3_role.name
  policy_arn = aws_iam_policy.terraform_s3_policy.arn
}

# Create the S3 bucket
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "secure-app-bucket-unique12345"
}

# Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket_encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Set bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "secure_bucket_ownership" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "secure_bucket_versioning" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Validate S3 bucket
resource "null_resource" "s3_validation" {
  provisioner "local-exec" {
    command = "python validate_s3.py"
  }
  depends_on = [
    aws_s3_bucket.secure_bucket,
    aws_iam_role.terraform_s3_role,
    aws_iam_role_policy_attachment.terraform_s3_policy_attach
  ]
}

output "s3_bucket_encryption" {
  value = aws_s3_bucket_server_side_encryption_configuration.secure_bucket_encryption
}

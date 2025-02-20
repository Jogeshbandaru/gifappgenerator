resource "aws_s3_bucket" "secure_bucket" {
  bucket = "secure-app-bucket-unique12345" # Change to a globally unique name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket_encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "secure_bucket_ownership" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}


resource "aws_s3_bucket_versioning" "secure_bucket_versioning" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

output "s3_bucket_encryption" {
  value = aws_s3_bucket_server_side_encryption_configuration.secure_bucket_encryption
}

resource "null_resource" "s3_validation" {
  provisioner "local-exec" {
    command = "python validate_s3.py"
  }
  depends_on = [aws_s3_bucket.secure_bucket]
}
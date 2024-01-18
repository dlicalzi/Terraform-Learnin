resource "aws_s3_bucket" "backend" {
  bucket = "dlmakesabucketfromterraform" #must be globally unique
}
resource "aws_s3_bucket_versioning" "backend" {
  bucket = aws_s3_bucket.backend.id
  versioning_configuration {
    status = "Disabled"
  }
}
resource "aws_s3_bucket_public_access_block" "backend" {
  bucket                  = aws_s3_bucket.backend.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
#s3 resource bucket policy
data "aws_iam_policy_document" "backend" {
  statement {
    sid = "Public View"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.backend.arn, "${aws_s3_bucket.backend.arn}/*"
    ]

  }
}

resource "aws_s3_bucket_policy" "backend" {
  bucket = aws_s3_bucket.backend.id
  policy = data.aws_iam_policy_document.backend.json
}
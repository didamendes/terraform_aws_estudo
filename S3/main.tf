terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "diogo_s3" {
  bucket = "diogo-mendes-teste"
  force_destroy = true

  tags = {
    Name        = "diogo_bucket_exemplo"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning_config" {
  bucket = aws_s3_bucket.diogo_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_s3" {
  bucket = aws_s3_bucket.diogo_s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "aula_bucket_policy" {
  bucket = aws_s3_bucket.diogo_s3.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : {
      "Effect" : "Allow",
      "Principal" : "*",
      "Action" : ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      "Resource" : "${aws_s3_bucket.diogo_s3.arn}/*"
    }
  })

}
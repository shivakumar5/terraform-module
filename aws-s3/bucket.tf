provider "aws" {
    version = "~> 2.3"
    region = "${var.region}"
}

terraform {
  required_version = "~> 0.11"
}

resource "aws_s3_bucket" "test_log_bucket" {
  bucket = "my-tf-log-bucket-shiva-test"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "testbuckets3" {
    bucket = "${var.bucketname}"

    versioning {
    enabled = true
    }

    tags {
        Name        = "${var.bucketname}"
        Environment = "${var.env}"
        }

    server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = "${aws_s3_bucket.test_log_bucket.id}"
    target_prefix = "log/"
  }

  lifecycle_rule {
    prefix  = "config/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 90
    }
  }

}


resource "aws_s3_bucket_public_access_block" "publicaccess" {
  bucket = "${aws_s3_bucket.testbuckets3.id}"

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets  = true
}


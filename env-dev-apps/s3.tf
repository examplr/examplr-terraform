
resource "aws_s3_bucket" "accessible_bucket" {
  bucket = "${var.app_env}-${var.app_name}-bucket1"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "accessible_bucket_acl" {
  bucket = aws_s3_bucket.accessible_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "accessible_bucket_file" {
  bucket = "${var.app_env}-${var.app_name}-bucket1"
  key    = "helloworld.txt"
  source = "../files/s3/helloworld.txt"
  depends_on = [aws_s3_bucket.accessible_bucket]
}

resource "aws_s3_bucket" "inaccessible_bucket" {
  bucket = "${var.app_env}-${var.app_name}-bucket2"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "inaccessible_bucket_acl" {
  bucket = aws_s3_bucket.inaccessible_bucket.id
  acl    = "private"

}

resource "aws_s3_object" "inaccessible_bucket_file" {
  bucket = "${var.app_env}-${var.app_name}-bucket2"
  key    = "helloworld.txt"
  source = "../files/s3/helloworld.txt"
  depends_on = [aws_s3_bucket.inaccessible_bucket]
}


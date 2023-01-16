
resource "aws_s3_bucket" "accessible_bucket" {
  bucket = "examplr-helloworld-${var.app_environment}"
}

resource "aws_s3_bucket_acl" "accessible_bucket_acl" {
  bucket = aws_s3_bucket.accessible_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "accessible_bucket_file" {
  bucket ="examplr-helloworld-${var.app_environment}"
  key    = "helloworld.txt"
  source = "../files/helloworld.txt"
  depends_on = [aws_s3_bucket.accessible_bucket]
}




resource "aws_s3_bucket" "inaccessible_bucket" {
  bucket = "examplr-helloworld-private-${var.app_environment}"
}

resource "aws_s3_bucket_acl" "inaccessible_bucket_acl" {
  bucket = aws_s3_bucket.inaccessible_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "inaccessible_bucket_file" {
  bucket = "examplr-helloworld-private-${var.app_environment}"
  key    = "helloworld.txt"
  source = "../files/helloworld.txt"
  depends_on = [aws_s3_bucket.inaccessible_bucket]
}



data "aws_route53_zone" "root" {
  name         = "examplr.co"
  private_zone = false
}

resource "aws_route53_zone" "dev" {
  provider = aws.dev
  name = "dev.examplr.co"
  tags = {
    Environment = "dev"
  }
}

resource "aws_route53_record" "dev-ns" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = "dev.examplr.co"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.dev.name_servers
}


resource "aws_route53_zone" "prod" {
  provider = aws.prod
  name = "api.examplr.co"
  tags = {
    Environment = "dev"
  }
}

resource "aws_route53_record" "prod-ns" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = "api.examplr.co"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.dev.name_servers
}
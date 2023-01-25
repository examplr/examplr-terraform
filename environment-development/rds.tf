module "mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.2.3"

  identifier = "${var.app_env}-${var.app_name}-mysql"

  instance_class         = "db.t2.small"
  engine                 = "mysql"
  family                 = "mysql8.0"
  engine_version         = "8.0"
  major_engine_version   = "8.0"
  allocated_storage      = 5
  port                   = "3306"
  username               = var.mysql_user
  password               = var.mysql_pass
  create_random_password = false

  create_db_subnet_group = false
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [aws_security_group.mysql_ingress.id]

  deletion_protection = false
  skip_final_snapshot = true
  apply_immediately   = true

}

resource "aws_security_group" "mysql_ingress" {

  name        = "${var.app_env}-${var.app_name}-mysql-1-db"
  description = "Allow inbound port 3306 traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "lookup_db_domain_zone" {
  source = "../modules/terraform-aws-dns-zone-lookup"
  domain_name = "!${var.app_env}.examplr.co"
}
resource "aws_route53_record" "cname" {
  zone_id = module.lookup_db_domain_zone.zone_id
  name    = "mysql.${var.app_domain}"
  type    = "CNAME"
  ttl     = 300
  records = [module.mysql.db_instance_address]
}


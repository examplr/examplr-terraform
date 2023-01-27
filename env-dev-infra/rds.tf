
resource "aws_db_subnet_group" "mysql_sg" {
  name       = "${var.app_env}-${var.app_name}-mysql-sg"
  subnet_ids = var.vpc_database_subnet_ids

  tags = {
    Name = "${var.app_env}-${var.app_name}-mysql-sg"
  }
}


module "mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.2.3"

  identifier = "${var.app_env}-${var.app_name}-mysql"

  instance_class         = var.mysql_class
  engine                 = "mysql"

  major_engine_version   = "8.0"
  engine_version         = "8.0"

  allocated_storage      = var.mysql_storage
  port                   = "3306"
  username               = var.mysql_user
  password               = var.mysql_pass
  create_random_password = false

  create_db_subnet_group = false
  db_subnet_group_name   = aws_db_subnet_group.mysql_sg.name


  vpc_security_group_ids = [aws_security_group.mysql_ingress.id]

  deletion_protection = false
  skip_final_snapshot = true
  apply_immediately   = true

  //-- parameter group
  family                 = "mysql8.0"
  parameters = [
    {
      //allows users to run triggers
      name = "log_bin_trust_function_creators"
      value = "1"
    }
  ]

}

resource "aws_security_group" "mysql_ingress" {
  name        = "${var.app_env}-${var.app_name}-mysql-ingress"
  description = "Allow inbound port 3306 traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "lookup_db_domain_zone" {
  source = "../modules/terraform-aws-dns-zone-lookup"
  domain_name = "!${var.app_domain}"
}

resource "aws_route53_record" "mysql" {
  zone_id = module.lookup_db_domain_zone.zone_id
  name    = "mysql.${var.app_domain}"
  type    = "CNAME"
  ttl     = 300
  records = [module.mysql.db_instance_address]
}


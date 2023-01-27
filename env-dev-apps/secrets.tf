
locals{
  secrets_file = fileexists("./secrets.json") ? jsondecode(file("./secrets.json")) : {}
  secrets = merge(local.secrets_file, var.secrets)
}



resource "aws_secretsmanager_secret" "secret" {
  name = "${var.app_env}-${var.app_name}"

  //-- if this is not here, AWS will keep your secret for 30 days and you can not
  //-- destroy and recreate your environment because this will conflict with the
  //-- secret that you just deleted but has not actually been deleted yet
  recovery_window_in_days = 0
}


resource "aws_secretsmanager_secret_version" "values" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(local.secrets)

}
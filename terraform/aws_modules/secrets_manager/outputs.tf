output "db_secrets" {
  value = {
    db_username = jsondecode(
      data.aws_secretsmanager_secret_version.db_secrets.secret_string
    )["DB_USER"]

    db_password = jsondecode(
      data.aws_secretsmanager_secret_version.db_secrets.secret_string
    )["DB_PASSWORD"]
  }

  sensitive = true
}
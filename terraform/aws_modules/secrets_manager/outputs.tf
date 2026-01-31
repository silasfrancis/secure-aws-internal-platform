output "db_secrets" {
  value = {
    db_username = jsondecode(data.aws_secretsmanager_secret_version.db_secrets)[DB_USER]
    db_password = jsondecode(data.aws_secretsmanager_secret_version.db_secrets)[DB_PASSWORD]
  }
}
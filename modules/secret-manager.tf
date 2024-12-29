resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "rdssecret" {
  description             = "RDS credentials"
  name                    = "rds-username-password"
  recovery_window_in_days = 14
  kms_key_id              = aws_kms_key.mykey.key_id

}

resource "aws_secretsmanager_secret_version" "rdssecret" {
  secret_id     = aws_secretsmanager_secret.rdssecret.id
  secret_string = random_password.password.result
}

data "aws_secretsmanager_secret" "rdssecret" {
  name       = "rds-username-password"
  depends_on = [aws_secretsmanager_secret.rdssecret]
}

data "aws_secretsmanager_secret_version" "rdssecret" {
  secret_id = data.aws_secretsmanager_secret.rdssecret.id
}
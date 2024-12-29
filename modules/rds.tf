
resource "aws_db_instance" "database" {
  identifier = "myproject-${var.environment}"

  engine         = "mysql"
  engine_version = "8.0.39"
  instance_class = var.database["instance_class"]

  publicly_accessible = "false"
  multi_az            = var.database["multi_az"]
  storage_encrypted   = var.database["encrypted"]

  storage_type      = "gp2"
  allocated_storage = var.database["storage_size"]

  db_name  = var.database["name"]
  username = var.database["username"]
  /* manage_master_user_password   = true
  master_user_secret_kms_key_id = aws_kms_key.mykey.key_id */
  password = data.aws_secretsmanager_secret_version.rdssecret.secret_string



  backup_window             = "01:00-02:00"
  backup_retention_period   = 7
  skip_final_snapshot       = false
  final_snapshot_identifier = "myproject-${var.environment}-final-snapshot"

  db_subnet_group_name = aws_db_subnet_group.database.id
  vpc_security_group_ids = [
    "${aws_security_group.access_to_database.id}"
  ]

  tags = {
    "Name"        = "${var.environment}.Database"
    "Project"     = "My project"
    "Environment" = "${var.environment}"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_db_instance" "replica-public" {
  count = var.database["number_of_replicas"]

  identifier = "myproject-${var.environment}-replica-db"

  engine               = "mysql"
  engine_version       = "8.0.39"
  instance_class       = var.database["instance_class"]
  publicly_accessible  = "true"
  multi_az             = "false"
  db_subnet_group_name = aws_db_subnet_group.database-replica[count.index].name
  storage_encrypted    = var.database["encrypted"]
  apply_immediately    = "true"

  allocated_storage = var.database["storage_size"]
  storage_type      = "gp2"

  /*  db_name  = var.database["name"]
  username = var.database["username"] 
  password  = "${var.database["password"]}"*/
  password = data.aws_secretsmanager_secret_version.rdssecret.secret_string

  replicate_source_db = aws_db_instance.database.arn
  #replicate_source_db = aws_db_instance.database.id
  skip_final_snapshot = true

  vpc_security_group_ids = [
    "${aws_security_group.access_to_database_replica.id}"
  ]

  tags = {
    "Name"        = "${var.environment}.Replica-Db.${count.index}"
    "Project"     = "My Project"
    "Environment" = "${var.environment}"
  }

  /* lifecycle {
    prevent_destroy = true
  } */
}

resource "aws_db_subnet_group" "database" {
  name        = "${var.environment}-database"
  description = "Database Subnet Group for ${var.environment}"
  subnet_ids  = [for subnet in aws_subnet.private : subnet.id]
  tags = {
    "Name"        = "${var.environment}-Subnet-Group-Database"
    "Project"     = "My Project"
    "Environment" = "${var.environment}"
  }
}

resource "aws_db_subnet_group" "database-replica" {
  count = var.database["number_of_replicas"]
  name  = "${var.environment}-database-replica"

  subnet_ids = [for subnet in aws_subnet.public : subnet.id]
  tags = {
    "Name"        = "${var.environment}-Subnet-Group-Database"
    "Project"     = "My Project"
    "Environment" = "${var.environment}"
  }
}
# Creating KMS key used to encrypt secrets used in different services 

resource "aws_kms_key" "mykey" {
  description             = "KMS key for credentials"
  deletion_window_in_days = 7 #to define the period depending on how often do you want to keep the same key # Careful! it may lead to recreate the RDS=> to be tested 
  is_enabled              = true
  enable_key_rotation     = true
}


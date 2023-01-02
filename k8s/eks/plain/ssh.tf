module "test_ec2" {
  source = "../../../tf_modules/test_ec2"

  count = var.enable_test_ec2 ? 1 : 0

  vpc = module.vpc
}

resource "tls_private_key" "kp" {
  count = var.enable_ssh ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  count = var.enable_ssh ? 1 : 0

  key_name   = "kp"
  public_key = tls_private_key.kp.0.public_key_openssh
}

resource "local_sensitive_file" "this" {
  count = var.enable_ssh ? 1 : 0

  content         = tls_private_key.kp.0.private_key_openssh
  filename        = "id_rsa"
  file_permission = "0600"
}

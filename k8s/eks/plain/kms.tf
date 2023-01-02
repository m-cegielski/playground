resource "aws_kms_key" "this" {}

resource "aws_kms_alias" "this" {
  name          = "alias/etcd"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_kms_key" "this" {
  description             = "kms-${local.name_suffix}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "enable_test_ec2" {
  type    = bool
  default = false
}

variable "enable_ssh" {
  type    = bool
  default = false
}

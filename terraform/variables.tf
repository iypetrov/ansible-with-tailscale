locals {
  vpc_cidr = "10.10.0.0/16"
}

variable "aws_access_key_id" {
  type      = string
  sensitive = true
}

variable "aws_secret_access_key" {
  type      = string
  sensitive = true
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "tailscale_auth_key" {
  type      = string
  sensitive = true
}

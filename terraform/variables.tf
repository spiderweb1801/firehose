variable "app_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "splunk_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "app_name" {
  type    = string
  default = "app-aps1"
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "key_name" {
  type    = string
  default = "for-bastion-putty"
}
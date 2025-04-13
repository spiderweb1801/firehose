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

variable "splunk_hec_token" {
  type      = string
  default   = "0bada992-7be8-4cb4-b805-e9cd22038f69"
  sensitive = true
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "key_name" {
  type    = string
  default = "for-bastion-putty"
}
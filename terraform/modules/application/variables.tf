
locals {
  vpc = {
    public_subnets = {
      subnet1 = {
        name              = "public-subnet-1"
        cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 0)
        availability_zone = "${data.aws_region.current.name}a"
      },
      subnet2 = {
        name              = "public-subnet-2"
        cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
        availability_zone = "${data.aws_region.current.name}b"
      }
    },
    private_subnets = {
      subnet1 = {
        name              = "private-subnet-1"
        cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
        availability_zone = "${data.aws_region.current.name}a"
      },
      subnet2 = {
        name              = "private-subnet-2"
        cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 3)
        availability_zone = "${data.aws_region.current.name}b"
      }
    }
  }
}

variable "instance_config" {
  type = object({
    cidr_range   = string
    app_name     = string
    ami_id    = string
    instance_type = string
    key_name = string
    user_data = string
    public_enabled = bool
  })
  default = {
    cidr_range     = ""
    app_name       = ""
    ami_id         = ""
    instance_type  = ""
    key_name       = ""
    user_data      = ""
    public_enabled = false
  }
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  ]
}
variable "ubuntu_ami" {
  type    = string
  default = "ami-0e2c8caa4b6378d8c"
}

variable "amazonlinux_ami" {
  type = string
  default = "ami-0c614dee691cbbf37"
}
variable "instance_name" {
  type = string
  default = "Private Instance"
}

variable "subnet_id" {
  type = string
}

variable "ec2_instance_profile" {
  type = string
}


variable "security_group_id" {
  type = string
}

variable "instanceType" {
  type = string
  default = "t2.micro"
}

variable "public_subnet_id" {
  type = string
}

variable "security_group_id" {  
  type = string
  default = ""
}
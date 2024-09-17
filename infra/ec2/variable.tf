variable "instanceType" {
  type = string
  default = "t2.micro"
}

variable "public_subnet_ids" {
  type = list
  default = []
}

variable "security_group_id" {  
  type = string
  default = ""
}
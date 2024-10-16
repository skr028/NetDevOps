# Variables
variable "vpc_cidr_blocks" {
  default = {
    mumbai_dev  = "10.0.0.0/16"
    mumbai_prod = "10.1.0.0/16"
    sydney_dev  = "10.2.0.0/16"
    sydney_prod = "10.3.0.0/16"
    london_net  = "10.4.0.0/16"
  }
}

variable "subnet_cidr_blocks" {
  default = {
    mumbai_dev  = "10.0.1.0/24"
    mumbai_prod = "10.1.1.0/24"
    sydney_dev  = "10.2.1.0/24"
    sydney_prod = "10.3.1.0/24"
    london_net  = "10.4.1.0/24"
  }
}
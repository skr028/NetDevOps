module "ec2" {  
  source         = "./infra/ec2"
  instanceType   = "t3.medium"
}


module vpc {
  source               = "./infra/vpc"
  vpc_cidr             = "10.0.0.0/16"
  publicSubnet_cidr    = ["10.0.10.0/24", "10.180.0.0/24"]
  port                 = "80"
  internet_cidr        = "0.0.0.0/0" 
}
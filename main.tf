terraform {

  backend "s3" {

    bucket      = "test12341985"
	  key         = "terraform/terraform.tfstate"
	  region      = "us-east-1"

  }
}

module "ec2" {  
  source              = "./infra/ec2"
  instanceType        = "t3.medium"
  public_subnet_id    = module.vpc.public_subnet_ids[0]
  security_group_id   = module.vpc.security_group_id
}


module vpc {
  source               = "./infra/vpc"
  vpc_cidr             = "10.0.0.0/16"
  publicSubnet_cidr    = ["10.0.10.0/24", "10.0.20.0/24"]
  port                 = "80"
  internet_cidr        = "0.0.0.0/0" 
}
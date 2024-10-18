terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
     }
  }


  backend "s3" {

    bucket      = "test12341985"
	  key         = "terraform2/terraform.tfstate"
	  region      = "us-east-1"

  }
}
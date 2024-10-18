terraform {

  backend "s3" {

    bucket      = "test12341985"
	  key         = "terraform1/terraform.tfstate"
	  region      = "us-east-1"

  }
}
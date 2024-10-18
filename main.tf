terraform {

  backend "s3" {

    bucket      = "test12341985"
	  key         = "terraform3/terraform.tfstate"
	  region      = "us-east-1"

  }
}
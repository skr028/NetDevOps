terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
     }
  }
}

# Provider configuration
provider "aws" {
  region = "ap-south-1"
  alias  = "mumbai"
  
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "sydney"
}

provider "aws" {
  region = "eu-west-2"
  alias  = "london"  
}
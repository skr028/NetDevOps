# Provider configuration
provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"  
}

provider "aws" {
  alias  = "sydney"
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "london"
  region = "eu-west-2" 
}
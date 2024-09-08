terraform {
       backend "S3" {
         # The name of your Terraform Cloud organization.
         bucket      = "project-poc-test198565"
         key         = "netdevops/terraform/terraform.tfstate"
         region      = "us-east-1"
         }
       }

module "netdevOps" {  
  source = "./infra/"
}

# # Provider configuration
# provider "aws" {
#   region = "us-east-1"  # Global region for Cloud WAN
# }

# # Create a global network
# resource "aws_networkmanager_global_network" "global_network" {
#   description = "Global network for multi-region deployment"
# }

# # Create a core network
# resource "aws_networkmanager_core_network" "core_network" {
#   global_network_id = aws_networkmanager_global_network.global_network.id
#   description       = "Core network for multi-region deployment"
# }

# # Define the core network policy
# resource "aws_networkmanager_core_network_policy_attachment" "policy" {
#   core_network_id = aws_networkmanager_core_network.core_network.id
#   policy_document = jsonencode({
#     version = "2021.12"
#     core-network-configuration = {
#       asn-ranges = ["64512-65534"]
#       edge-locations = [
#         { location = "ap-south-1" },    # Mumbai
#         { location = "ap-southeast-2" }, # Sydney
#         { location = "eu-west-2" }      # London
#       ]
#     }
#     segments = [
#       {
#         name = "development"
#         isolate-attachments = false
#         require-attachment-acceptance = false
#       },
#       {
#         name = "production"
#         isolate-attachments = true
#         require-attachment-acceptance = true
#       },
#       {
#         name = "shared"
#         isolate-attachments = false
#         require-attachment-acceptance = false
#       }
#     ]
#     segment-actions = [
#       {
#         action = "share"
#         mode = "attachment-route"
#         segment = "shared"
#         share-with = "*"
#       }
#     ]
#     attachment-policies = [
#       {
#         rule-number = 100
#         conditions = [
#           {
#             type = "tag-exists"
#             key = "Segment"
#           }
#         ]
#         action = {
#           association-method = "tag"
#           tag-value-of-key = "Segment"
#         }
#       }
#     ]
#   })
# }

# # Create VPCs in each region
# resource "aws_vpc" "mumbai_vpc" {
#   provider = aws.mumbai
#   cidr_block = "10.1.0.0/16"
#   tags = {
#     Name = "Mumbai VPC"
#     Segment = "development"
#   }
# }

# resource "aws_vpc" "sydney_vpc" {
#   provider = aws.sydney
#   cidr_block = "10.2.0.0/16"
#   tags = {
#     Name = "Sydney VPC"
#     Segment = "production"
#   }
# }

# resource "aws_vpc" "london_vpc" {
#   provider = aws.london
#   cidr_block = "10.3.0.0/16"
#   tags = {
#     Name = "London VPC"
#     Segment = "shared"
#   }
# }

# # Create VPC attachments
# resource "aws_networkmanager_vpc_attachment" "mumbai_attachment" {
#   core_network_id = aws_networkmanager_core_network.core_network.id
#   vpc_arn         = aws_vpc.mumbai_vpc.arn
#   subnet_arns     = [aws_subnet.mumbai_subnet.arn]
#   tags = {
#     Segment = "development"
#   }
# }

# resource "aws_networkmanager_vpc_attachment" "sydney_attachment" {
#   core_network_id = aws_networkmanager_core_network.core_network.id
#   vpc_arn         = aws_vpc.sydney_vpc.arn
#   subnet_arns     = [aws_subnet.sydney_subnet.arn]
#   tags = {
#     Segment = "production"
#   }
# }

# resource "aws_networkmanager_vpc_attachment" "london_attachment" {
#   core_network_id = aws_networkmanager_core_network.core_network.id
#   vpc_arn         = aws_vpc.london_vpc.arn
#   subnet_arns     = [aws_subnet.london_subnet.arn]
#   tags = {
#     Segment = "shared"
#   }
# }

# # Create subnets in each VPC (one per region for simplicity)
# resource "aws_subnet" "mumbai_subnet" {
#   provider = aws.mumbai
#   vpc_id     = aws_vpc.mumbai_vpc.id
#   cidr_block = "10.1.1.0/24"
#   availability_zone = "ap-south-1a"
#   tags = {
#     Name = "Mumbai Subnet"
#   }
# }

# resource "aws_subnet" "sydney_subnet" {
#   provider = aws.sydney
#   vpc_id     = aws_vpc.sydney_vpc.id
#   cidr_block = "10.2.1.0/24"
#   availability_zone = "ap-southeast-2a"
#   tags = {
#     Name = "Sydney Subnet"
#   }
# }

# resource "aws_subnet" "london_subnet" {
#   provider = aws.london
#   vpc_id     = aws_vpc.london_vpc.id
#   cidr_block = "10.3.1.0/24"
#   availability_zone = "eu-west-2a"
#   tags = {
#     Name = "London Subnet"
#   }
# }

# # Provider configurations for each region
# provider "aws" {
#   alias  = "mumbai"
#   region = "ap-south-1"
# }

# provider "aws" {
#   alias  = "sydney"
#   region = "ap-southeast-2"
# }

# provider "aws" {
#   alias  = "london"
#   region = "eu-west-2"
# }

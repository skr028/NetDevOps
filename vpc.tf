# Configure AWS provider for multiple regions
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "ap-south-1"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
}

# Create VPCs
module "vpc_us_east_1_dev" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  providers = {
    aws = aws.us-east-1
  }

  name = "dev-vpc-us-east-1"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "dev"
    Region      = "us-east-1"
  }
}

module "vpc_us_east_1_prod" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  providers = {
    aws = aws.us-east-1
  }

  name = "prod-vpc-us-east-1"
  cidr = "10.1.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "prod"
    Region      = "us-east-1"
  }
}

module "vpc_ap_south_1_dev" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  providers = {
    aws = aws.ap-south-1
  }

  name = "dev-vpc-ap-south-1"
  cidr = "10.2.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  public_subnets  = ["10.2.101.0/24", "10.2.102.0/24", "10.2.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "dev"
    Region      = "ap-south-1"
  }
}

module "vpc_ap_south_1_prod" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  providers = {
    aws = aws.ap-south-1
  }

  name = "prod-vpc-ap-south-1"
  cidr = "10.3.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24"]
  public_subnets  = ["10.3.101.0/24", "10.3.102.0/24", "10.3.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "prod"
    Region      = "ap-south-1"
  }
}

module "vpc_ap_southeast_2_shared" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  providers = {
    aws = aws.ap-southeast-2
  }

  name = "shared-vpc-ap-southeast-2"
  cidr = "10.4.0.0/16"

  azs             = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  private_subnets = ["10.4.1.0/24", "10.4.2.0/24", "10.4.3.0/24"]
  public_subnets  = ["10.4.101.0/24", "10.4.102.0/24", "10.4.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "shared"
    Region      = "ap-southeast-2"
  }
}

# Create security groups for EC2 instances
resource "aws_security_group" "allow_ssh" {
  for_each = {
    "us-east-1-dev"     = module.vpc_us_east_1_dev.vpc_id
    "us-east-1-prod"    = module.vpc_us_east_1_prod.vpc_id
    "ap-south-1-dev"    = module.vpc_ap_south_1_dev.vpc_id
    "ap-south-1-prod"   = module.vpc_ap_south_1_prod.vpc_id
    "ap-southeast-2"    = module.vpc_ap_southeast_2_shared.vpc_id
  }

  name        = "allow_ssh_${each.key}"
  description = "Allow SSH inbound traffic"
  vpc_id      = each.value

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["49.37.39.37/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_${each.key}"
  }

  # provider = local.region_providers[each.value.region]
  
}

# Create EC2 instances with Apache
resource "aws_instance" "web_server" {
  for_each = {
    "us-east-1-dev"     = { vpc = module.vpc_us_east_1_dev, provider = aws.us-east-1 }
    "us-east-1-prod"    = { vpc = module.vpc_us_east_1_prod, provider = aws.us-east-1 }
    "ap-south-1-dev"    = { vpc = module.vpc_ap_south_1_dev, provider = aws.ap-south-1 }
    "ap-south-1-prod"   = { vpc = module.vpc_ap_south_1_prod, provider = aws.ap-south-1 }
    "ap-southeast-2"    = { vpc = module.vpc_ap_southeast_2_shared, provider = aws.ap-southeast-2 }
  }

  ami           = data.aws_ami.amazon_linux_2[each.key].id
  instance_type = "t2.micro"
  subnet_id     = each.value.vpc.public_subnets[0]

  vpc_security_group_ids = [aws_security_group.allow_ssh[each.key].id]

  # provider = local.region_providers[each.value.region]

}

# Data source for Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  for_each = {
    "us-east-1-dev"     = "us-east-1"
    "us-east-1-prod"    = "us-east-1"
    "ap-south-1-dev"    = "ap-south-1"
    "ap-south-1-prod"   = "ap-south-1"
    "ap-southeast-2"    = "ap-southeast-2"
  }

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  # provider = local.region_providers[each.value]
}

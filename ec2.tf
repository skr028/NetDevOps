# Security Groups
resource "aws_security_group" "allow_ssh" {
  for_each = {
    mumbai_dev  = aws_vpc.mumbai_dev.id
    mumbai_prod = aws_vpc.mumbai_prod.id
    sydney_dev  = aws_vpc.sydney_dev.id
    sydney_prod = aws_vpc.sydney_prod.id
    london_net  = aws_vpc.london_net.id
  }

  name        = "allow_ssh_${each.key}"
  description = "Allow SSH inbound traffic"
  vpc_id      = each.value

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow-SSH-${each.key}"
  }

#   provider = each.key == "london_net" ? aws.london : (
#     contains(["sydney_dev", "sydney_prod"], each.key) ? aws.sydney : aws.mumbai
#   )
}

# EC2 Instances
data "aws_ami" "amazon_linux_2" {
  for_each = toset(["mumbai", "sydney", "london"])

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

#   provider = each.key == "london" ? aws.london : (
#     each.key == "sydney" ? aws.sydney : aws.mumbai
#   )
}

resource "aws_instance" "ec2_instances" {
  for_each = {
    # mumbai_dev  = { provider = aws.mumbai, subnet = aws_subnet.mumbai_dev.id, sg = aws_security_group.allow_ssh["mumbai_dev"].id }
    # mumbai_prod = { provider = aws.mumbai, subnet = aws_subnet.mumbai_prod.id, sg = aws_security_group.allow_ssh["mumbai_prod"].id }
    # sydney_dev  = { provider = aws.sydney, subnet = aws_subnet.sydney_dev.id, sg = aws_security_group.allow_ssh["sydney_dev"].id }
    # sydney_prod = { provider = aws.sydney, subnet = aws_subnet.sydney_prod.id, sg = aws_security_group.allow_ssh["sydney_prod"].id }
    # london_net  = { provider = aws.london, subnet = aws_subnet.london_net.id, sg = aws_security_group.allow_ssh["london_net"].id }
    mumbai_dev  = { subnet = aws_subnet.mumbai_dev.id, sg = aws_security_group.allow_ssh["mumbai_dev"].id }
    mumbai_prod = { subnet = aws_subnet.mumbai_prod.id, sg = aws_security_group.allow_ssh["mumbai_prod"].id }
    sydney_dev  = { subnet = aws_subnet.sydney_dev.id, sg = aws_security_group.allow_ssh["sydney_dev"].id }
    sydney_prod = { subnet = aws_subnet.sydney_prod.id, sg = aws_security_group.allow_ssh["sydney_prod"].id }
    london_net  = { subnet = aws_subnet.london_net.id, sg = aws_security_group.allow_ssh["london_net"].id }
  }

#   provider      = each.value.provider
  ami           = data.aws_ami.amazon_linux_2[split("_", each.key)[0]].id
  instance_type = "t2.micro"
  subnet_id     = each.value.subnet

  vpc_security_group_ids = [each.value.sg]

  tags = {
    Name = "EC2-${each.key}"
  }
}
data "aws_ami" "app_ami" {
  most_recent = true
  owners = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
resource "aws_instance" "tfpoc_instance" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instanceType
  # subnet_id     = aws_subnet.tfpoc_public_subnet.id
  subnet_id              = module.vpc.public_subnet_ids[0]
  
  vpc_security_group_ids = [module.vpc.security_group_id]

  user_data = templatefile("${path.module}/user_data.sh", {})

  tags = {
    Name = "tfpoc_apache_server"
  }
}


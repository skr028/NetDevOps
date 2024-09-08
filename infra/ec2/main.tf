resource "aws_instance" "tfpoc_instance" {
    ami = data.aws_ami.app_ami.id
    instance_type = var.instanceType
    subnet_id = aws_subnet.tfpoc_private_subnet.id
    #security_groups = [aws_security_group.lb_sg.id]

    user_data = <<EOF
    #!/bin/bash
    sudo yum install -y httpd
    sudo systemctl start httpd.service
    sudo systemctl enable httpd.service
    echo 'Started Apache from Terraform' > /var/www/html/index.html
    EOF

    tags = {
        Name = "tfpoc_apacheserver"
    }
}

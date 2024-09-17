output "security_group_id" {
  value = aws_security_group.instance_sg.id
}


output "public_subnet_ids" {
  value = aws_subnet.tfpoc_public_subnet[*].id
}


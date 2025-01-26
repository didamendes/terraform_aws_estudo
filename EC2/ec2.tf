resource "aws_instance" "web_ec2" {
  ami                         = var.ec2_ami
  instance_type               = var.web_ec2_instance_type
  subnet_id                   = aws_subnet.dio_subnet_publica.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.diogo_sg_web.id]
  key_name                    = aws_key_pair.diogo_ssh.key_name
  user_data                   = file("C:/Users/didam/Desktop/TERRAFORM/AWS/EC2/instalacao-docker.sh")

  tags = {
    Name = var.web_ec2_name
  }

}

resource "aws_instance" "db_ec2" {
  ami                    = var.ec2_ami
  instance_type          = var.db_ec2_instance_type
  subnet_id              = aws_subnet.dio_subnet_privada.id
  vpc_security_group_ids = [aws_security_group.diogo_sg_db.id]
  key_name               = aws_key_pair.diogo_ssh.key_name
  user_data              = file("C:/Users/didam/Desktop/TERRAFORM/AWS/EC2/instalacao-docker.sh")

  tags = {
    Name = var.db_ec2_name
  }

}

resource "aws_key_pair" "diogo_ssh" {
  key_name   = var.kpair_ssh_name
  public_key = file(var.kpair_ssh_file)
}

output "web_ip" {
  value = aws_instance.web_ec2.public_ip
}

output "db_ip" {
  value = aws_instance.db_ec2.private_ip
}
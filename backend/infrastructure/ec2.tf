# Aktuelles Amazon Linux 2023 AMI suchen
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2-Server für GroceryMate
resource "aws_instance" "grocerymate" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Name = "grocerymate-ec2"
  }
}
/*
Terraform-Code	                      Erklärung
data "aws_ami"	                      Sucht ein passendes Amazon-Linux-Image
most_recent = true     	              Verwendet das neueste passende Image
owners = ["amazon"]	                  Nur offizielle Amazon-Images
aws_instance	                      Definiert einen EC2-Server
instance_type = "t3.micro"  	      Legt die Servergröße fest
subnet_id	                          Platziert EC2 im ersten Subnet
vpc_security_group_ids	              Verwendet deine EC2-Security-Group
tags	                              Name in der AWS-Konsole


Dieser Code definiert zunächst nur die EC2-Instanz. 
Er installiert und startet deine GroceryMate-Flask-Anwendung noch nicht.
 Dafür benötigen wir später eine Startkonfiguration (user_data) oder einen anderen Deployment-Prozess.
*/
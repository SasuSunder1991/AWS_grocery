# ==========================================
# 1. Security Group für den Load Balancer
# ==========================================

resource "aws_security_group" "alb" {
  name        = "grocerymate-alb-sg"
  description = "Security Group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  # Eingehender Verkehr: HTTP Port 80
  ingress {
    description = "Allow HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ausgehender Verkehr
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "grocerymate-alb-sg"
  }
}


# ==========================================
# 2. Security Group für EC2 (Flask)
# ==========================================

resource "aws_security_group" "ec2" {
  name        = "grocerymate-ec2-sg"
  description = "Allow Flask traffic from ALB"
  vpc_id      = aws_vpc.main.id

  # Eingehender Verkehr: Flask Port 5000
  # Nur vom Load Balancer erlaubt
  ingress {
    description     = "Flask from ALB"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Ausgehender Verkehr
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "grocerymate-ec2-sg"
  }
}






/*
1. ALB Security Group: Erlaubt HTTP-Verbindungen aus dem Internet auf Port 80.
2. EC2 Security Group: Erlaubt Verbindungen auf Port 5000 nur vom Load Balancer.
LB Security Group	EC2 Security Group

              	          ALB Security Group	      EC2 Security Group
Terraform-Name	               alb	                   ec2
Port	                       80	                   5000
Wer darf zugreifen?	          Internet	              Nur ALB
*/
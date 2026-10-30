# ==========================================
# 1. Application Load Balancer erstellen
# ==========================================

resource "aws_lb" "grocerymate" {
  name               = "grocerymate-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb.id]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name = "grocerymate-alb"
  }
}


# ==========================================
# 2. Target Group erstellen
# ==========================================

resource "aws_lb_target_group" "grocerymate" {
  name        = "grocerymate-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "grocerymate-tg"
  }
}


# ==========================================
# 3. EC2 bei Target Group registrieren
# ==========================================

resource "aws_lb_target_group_attachment" "grocerymate" {
  target_group_arn = aws_lb_target_group.grocerymate.arn
  target_id        = aws_instance.grocerymate.id
  port             = 5000
}


# ==========================================
# 4. HTTP Listener auf Port 80 erstellen
# ==========================================

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.grocerymate.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grocerymate.arn
  }
}
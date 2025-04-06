# ECS Clusters
resource "aws_ecs_cluster" "staging_cluster" {
  name = "petclinic-staging-cluster"
}

resource "aws_ecs_cluster" "prod_cluster" {
  name = "petclinic-prod-cluster"
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "staging_logs" {
  name              = "/ecs/petclinic-staging"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "prod_logs" {
  name              = "/ecs/petclinic-production"
  retention_in_days = 30
}

# SNS Topics for Alarms
resource "aws_sns_topic" "staging_alerts" {
  name = "petclinic-staging-alerts"
}

resource "aws_sns_topic" "prod_alerts" {
  name = "petclinic-production-alerts"
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "staging_high_cpu" {
  alarm_name          = "petclinic-staging-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ECS CPU utilization for staging"
  alarm_actions       = [aws_sns_topic.staging_alerts.arn]
  dimensions = {
    ClusterName = aws_ecs_cluster.staging_cluster.name
    ServiceName = "petclinic-service-staging"
  }
}

resource "aws_cloudwatch_metric_alarm" "prod_high_cpu" {
  alarm_name          = "petclinic-production-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ECS CPU utilization for production"
  alarm_actions       = [aws_sns_topic.prod_alerts.arn]
  dimensions = {
    ClusterName = aws_ecs_cluster.prod_cluster.name
    ServiceName = "petclinic-service-production"
  }
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "petclinic-alb-sg"
  description = "Security group for ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Prod ALB
resource "aws_lb" "petclinic_alb_prod" {
  name               = "petclinic-alb-prod"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids
}

resource "aws_lb_listener" "prod_listener" {
  load_balancer_arn = aws_lb.petclinic_alb_prod.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod_tg.arn
  }
}

# Staging ALB
resource "aws_lb" "petclinic_alb_staging" {
  name               = "petclinic-alb-staging"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids
}

resource "aws_lb_listener" "staging_listener" {
  load_balancer_arn = aws_lb.petclinic_alb_staging.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.staging_tg.arn
  }
}

# Target Groups
resource "aws_lb_target_group" "staging_tg" {
  name     = "petclinic-staging-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "prod_tg" {
  name     = "petclinic-prod-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

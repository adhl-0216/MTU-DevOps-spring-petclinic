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
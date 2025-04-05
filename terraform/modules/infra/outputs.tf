output "staging_cluster_id" {
  value = aws_ecs_cluster.staging_cluster.id
}

output "prod_cluster_id" {
  value = aws_ecs_cluster.prod_cluster.id
}

output "staging_log_group_name" {
  value = aws_cloudwatch_log_group.staging_logs.name
}

output "prod_log_group_name" {
  value = aws_cloudwatch_log_group.prod_logs.name
}
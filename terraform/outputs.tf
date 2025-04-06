output "staging_cluster_id" {
  value = module.infra.staging_cluster_id
}

output "prod_cluster_id" {
  value = module.infra.prod_cluster_id
}

output "staging_log_group_name" {
  value = module.infra.staging_log_group_name
}

output "prod_log_group_name" {
  value = module.infra.prod_log_group_name
}

output "task_definition_arn" {
  value = module.app.task_definition_arn
}
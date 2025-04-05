module "infra" {
  source = "./modules/infra"
}

module "app" {
  source             = "./modules/app"
  environment        = var.environment
  image_tag          = var.image_tag
  dockerhub_username = var.dockerhub_username
  cluster_id         = var.environment == "staging" ? module.infra.staging_cluster_id : module.infra.prod_cluster_id
  log_group_name     = var.environment == "staging" ? module.infra.staging_log_group_name : module.infra.prod_log_group_name
}

# Expose infra module outputs at the root level
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
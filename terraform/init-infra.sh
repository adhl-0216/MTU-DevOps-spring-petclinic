terraform init
terraform apply -target=module.infra -auto-approve
terraform output -raw module.infra.staging_cluster_id      # STAGING_CLUSTER_ID
terraform output -raw module.infra.prod_cluster_id        # PROD_CLUSTER_ID
terraform output -raw module.infra.staging_log_group_name # STAGING_LOG_GROUP_NAME
terraform output -raw module.infra.prod_log_group_name    # PROD_LOG_GROUP_NAME
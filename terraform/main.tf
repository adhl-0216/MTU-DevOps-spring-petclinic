module "app" {
  source             = "./modules/app"
  environment        = var.environment
  image_tag          = var.image_tag
  dockerhub_username = var.dockerhub_username
  subnet_ids         = var.subnet_ids
}

module "infra" {
  source             = "./modules/infra"
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
}

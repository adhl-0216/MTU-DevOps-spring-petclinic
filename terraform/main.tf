module "app" {
  source             = "./modules/app"
  environment        = var.environment
  image_tag          = var.image_tag
  dockerhub_username = var.dockerhub_username
  subnet_ids         = var.subnet_ids
  labrole_arn        = var.labrole_arn
}

module "infra" {
  source             = "./modules/infra"
  environment        = var.environment
  image_tag          = var.image_tag
  dockerhub_username = var.dockerhub_username
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  labrole_arn        = var.labrole_arn
}


# terraform {
#   backend "s3" {
#     bucket         = "petclinic-terraform-state-bucket"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     use_lockfile   = "terraform-locks"
#   }
# }
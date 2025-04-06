variable "environment" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "dockerhub_username" {
  type = string
}

variable "labrole_arn" {
  type = string
  default = "arn:aws:iam::215262883158:role/LabRole"
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS service"
  type        = list(string)
}
variable "environment" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "dockerhub_username" {
  type = string
}

variable "vpc_id" {
  type        = string
}

variable "labrole_arn" {
  type = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS service"
  type        = list(string)
}

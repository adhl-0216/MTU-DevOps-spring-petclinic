variable "vpc_id" {
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS service"
  type        = list(string)
}

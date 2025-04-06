variable "environment" {
  type = string
  default= "staging"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "dockerhub_username" {
  type    = string
  default = "adhlo216"
}

variable "labrole_arn" {
  type = string
  default = "arn:aws:iam::215262883158:role/LabRole"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0dbb8d966ba500adb"
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS service"
  type        = list(string)
  default = [
    "subnet-0bf83b18a617f4b33",
    "subnet-0e0eaedd336f971e3",
    "subnet-091765090f534e073",
    "subnet-0ce390d316b25b702",
    "subnet-013444a856452b902",
    "subnet-052e2ceaea77ebb20"
  ]
}
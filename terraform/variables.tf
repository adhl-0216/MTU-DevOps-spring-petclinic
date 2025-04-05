variable "environment" {
  type = string
}

variable "image_tag" {
  type    = string
  default = ""
}

variable "dockerhub_username" {
  type    = string
  default = ""
}

variable "log_group_name" {
  type    = string
  default = ""
}

variable "cluster_id" {
  type    = string
  default = ""
}
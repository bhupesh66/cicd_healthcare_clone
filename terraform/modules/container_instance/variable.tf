variable "prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}



variable "docker_image" {
  type = string
  default = "airflow"
}

variable "image_tag" {
  type = string
  default = "latest"
}

variable "environment_variables" {
  type = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}



variable "acr_username" {
  description = "ACR Username"
  type        = string
}

variable "acr_password" {
  description = "ACR Password"
  type        = string
}

variable "acr_login_server" {
  description = "The login server of the Azure Container Registry"
  type        = string
}
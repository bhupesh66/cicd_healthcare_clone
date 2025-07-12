variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "acr_name" {
  description = "acr_name"
  type        = string
}

variable "prefix" {
  description = "prefix"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

variable "docker_image" {
  description = "docker_image"
  type        = string
}
variable "image_tag" {
  description = "image_tag"
  type        = string
}

variable "environment_variables" {
  type = map(string)
  description = "Map of environment variables to pass to the container"
  default = {}
}


variable "tags" {
  default = {
    environment = "dev"
    project     = "airflow"
  }
}

variable "azure_client_id" {
    type=string
  
}

variable "azure_client_secret" {
    type=string
  
}

variable "azure_tenant_id" {
    type=string
  
}
variable "azure_subscription_id" {
    type=string
  
}

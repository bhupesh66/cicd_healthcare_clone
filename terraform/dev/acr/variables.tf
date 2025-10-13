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
  type        = map(string)
  description = "Map of environment variables to pass to the container"
  default     = {}
}


variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
    project     = "airflow"
  }
}


variable "AZURE_SUBSCRIPTION_ID" {
  type        = string
  description = "Azure Subscription ID"
}

variable "ACR_CLIENT_ID" {
  type        = string
  description = "Azure Container Registry client ID"
}

variable "ACR_CLIENT_SECRET" {
  type        = string
  description = "Azure Container Registry client secret"
}

variable "ACR_TENANT_ID" {
  type        = string
  description = "Azure Tenant ID"
}


variable "acr_sp_username" {
  type        = string
  description = "ACR service principal username"
}

variable "acr_sp_password" {
  type        = string
  description = "ACR service principal password"
}




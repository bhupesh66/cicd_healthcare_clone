variable "resource_group_name" {}
variable "location" { default = "Sweden Central" }

variable "log_analytics_workspace_name" { default = "central-law" }

variable "storage_account_name" {}
variable "container_name" { default = "rawdata" }

variable "servicebus_namespace" {}
variable "servicebus_queue" { default = "airflowqueue" }

variable "function_name" {}
variable "function_storage_account" {}

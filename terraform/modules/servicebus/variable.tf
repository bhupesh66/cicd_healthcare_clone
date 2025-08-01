
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}

variable "log_analytics_workspace" {
  type = string
}

variable "servicebus_namespace" {
  description = "Name of the Service Bus namespace"
  type        = string
}

variable "servicebus_queue" {
  description = "Name of the Service Bus queue"
  type        = string
}

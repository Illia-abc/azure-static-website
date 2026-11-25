variable "subscription_id" {
  description = "The subscription ID for the Azure account."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string

}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
  default     = "dev"
}
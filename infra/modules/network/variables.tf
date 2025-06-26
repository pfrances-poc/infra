variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)"
  default     = "dev"
}

variable "name" {
  type        = string
  description = "VPC name"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.name))
    error_message = "VPC name must consist of alphanumeric characters and hyphens only."
  }

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "VPC name must be between 1 and 64 characters long."
  }
}

variable "description" {
  type        = string
  description = "VPC description"
  default     = "Default network for the project"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"

  validation {
    condition     = can(regex("^(\\d{1,3}\\.){3}\\d{1,3}/\\d{1,2}$", var.cidr_block))
    error_message = "CIDR block must be in the format 'x.x.x.x/x' (e.g., '10.0.0/16')."
  }
}

variable "region" {
  type        = string
  description = "AWS region for the VPC"
  default     = "ap-northeast-1"
}

variable "azs_count" {
  type        = number
  description = "Number of Availability Zones to use"
  default     = 2

  validation {
    condition     = var.azs_count >= 1 && var.azs_count <= 6
    error_message = "azs_count must be between 1 and 6."
  }
}


variable "internet_gateway" {
  type        = bool
  description = "Whether to create an Internet Gateway"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags additionnels"
  default     = {}
}

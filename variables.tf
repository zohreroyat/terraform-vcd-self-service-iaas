variable "tenant_name" {
  description = "Tenant name"
  type        = string
}

variable "network_prefix_length" {
  description = "CIDR prefix length (24-28)"
  type        = number

  validation {
    condition     = var.network_prefix_length >= 24 && var.network_prefix_length <= 28
    error_message = "Prefix must be between /24 and /28"
  }
}

variable "vm_flavor" {
  description = "VM Flavor (1,2,3)"
  type        = number

  validation {
    condition     = contains([1,2,3], var.vm_flavor)
    error_message = "Flavor must be 1, 2 or 3"
  }
}

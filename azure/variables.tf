variable "location" {
  description = "The Azure Region in which all resources should be created."
  default     = "australiaeast"
}

variable "resource_group_name" {
  description = "The name of the resource group in which all resources should be created."
  default     = "tabby_group"
}

variable "vm_size" {
  description = "The size of the VM to create."
  default     = "Standard_NC6s_v3"
}
variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "dev-vnet"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "dev-subnet"
}

variable "nic_name" {
  description = "The name of the network interface"
  type        = string
  default     = "dev-nic"
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
  default     = "dev-vm"
}

variable "location" {
  description = "The location of the resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "The admin password for the VM"
  type        = string
  sensitive   = true
  default     = "Password123!"
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_B1ls"
}

variable "os_image" {
  description = "The OS image to use for the VM"
  type        = string
  default     = "Canonical:UbuntuServer:18.04-LTS:latest"
}

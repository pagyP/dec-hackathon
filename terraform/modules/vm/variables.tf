variable "prefix" { type = string }
variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "subnet_id" { type = string }
variable "os" { type = string }
variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "admin_ssh_key" {
  type    = string
  default = ""
}

variable "public_ip" {
  type    = bool
  default = false
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "linux_image" {
  type = object({ publisher = string, offer = string, sku = string, version = string })
  default = { publisher = "Canonical", offer = "UbuntuServer", sku = "20_04-lts", version = "latest" }
}

variable "windows_image" {
  type = object({ publisher = string, offer = string, sku = string, version = string })
  default = { publisher = "MicrosoftWindowsServer", offer = "WindowsServer", sku = "2019-datacenter", version = "latest" }
}

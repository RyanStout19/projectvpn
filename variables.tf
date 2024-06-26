variable "vm_name" {
  type    = string
  default = "asa-vm00"
}

variable "admin_username" {
  type    = string
  default = "stoutmondo"
}

variable "admin_password" {
  type    = string
  sensitive = true
  default = ""  # Make sure to change this to a secure password
}

variable "availability_zone" {
  type    = number
  default = 0
}

variable "vm_storage_account" {
  type    = string
  default = "projectvpnsto00"
}

variable "virtual_network_resource_group" {
  type    = string
  default = "projectvpn-rg"
}

variable "virtual_network_name" {
  type    = string
  default = "VNet1"
}

variable "mgmt_subnet_name" {
  type    = string
  default = "management"
}

variable "mgmt_subnet_ip" {
  type    = string
  default = "10.0.0.10"
}

variable "data1_subnet_name" {
  type    = string
  default = "data-subnet1"
}

variable "data1_subnet_ip" {
  type    = string
  default = "10.0.1.10"
}

variable "data2_subnet_name" {
  type    = string
  default = "data-subnet2"
}

variable "data2_subnet_ip" {
  type    = string
  default = "10.0.2.10"
}

variable "data3_subnet_name" {
  type    = string
  default = "data-subnet3"
}

variable "data3_subnet_ip" {
  type    = string
  default = "10.0.3.10"
}

variable "vm_size" {
  type    = string
  default = "Standard_D3_v2"
}

variable "location" {
  type    = string
  default = "northeurope"
}

variable "base_storage_uri" {
  type    = string
  default = ".blob.core.windows.net"
}

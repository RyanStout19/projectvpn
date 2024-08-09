variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "stoutmondo"
}
variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
}
variable "ASAvm_count" {
  description = "Number of ASAvm instances to deploy"
  type        = number
  default     = 1
}
resource "azurerm_resource_group" "projectvpn_rg" {
  name     = "projectvpn-2"
  location = "North Europe"
}
resource "azurerm_resource_group_template_deployment" "projectvpn" {
  name                = "projectvpn-rg"
  resource_group_name = azurerm_resource_group.projectvpn_rg.name
  deployment_mode     = "Complete"
  template_content = file("/home/stoutmondo/projectvpn/template_deployment1.json")
  parameters_content = jsonencode({
    vmNamePrefix = {
      value = "asa-vm"
    },
    adminUsername = {
      value = var.admin_username
    },
    adminPassword = {
      value = var.admin_password
    },
    availabilityZone = {
      value = 1
    },
    virtualNetworkResourceGroup = {
      value = azurerm_resource_group.projectvpn_rg.name
    },
    virtualNetworkName = {
      value = "projectvpn-vnet"
    },
    mgmtSubnetName = {
      value = "mgmt-subnet"
    },
    data1SubnetName = {
      value = "data1-subnet"
    },
    data2SubnetName = {
      value = "data2-subnet"
    },
    data3SubnetName = {
      value = "data3-subnet"
    },
    vmSize = {
      value = "Standard_D3_v2"
    },
    location = {
      value = azurerm_resource_group.projectvpn_rg.location
    },
    ASAvmCount = {
      value = var.ASAvm_count
    },
  })
  depends_on = [
    azurerm_resource_group.projectvpn_rg
  ]
}

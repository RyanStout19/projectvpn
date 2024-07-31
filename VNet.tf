resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.virtual_network_resource_group
  depends_on = [azurerm_resource_group_template_deployment.projectvpn]
}

resource "azurerm_subnet" "mgmt_subnet" {
  name                 = var.mgmt_subnet_name
  resource_group_name  = var.virtual_network_resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  depends_on = [azurerm_resource_group_template_deployment.projectvpn]
  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "data1_subnet" {
  name                 = var.data1_subnet_name
  resource_group_name  = var.virtual_network_resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  depends_on = [azurerm_resource_group_template_deployment.projectvpn]
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "data2_subnet" {
  name                 = var.data2_subnet_name
  resource_group_name  = var.virtual_network_resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  depends_on = [azurerm_resource_group_template_deployment.projectvpn]
  address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "data3_subnet" {
  name                 = var.data3_subnet_name
  resource_group_name  = var.virtual_network_resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  depends_on = [azurerm_resource_group_template_deployment.projectvpn]
  address_prefixes = ["10.0.3.0/24"]
}

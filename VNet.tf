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
  address_prefix = "{$var.mgmt_subnet_ip}"
}

resource "azurerm_subnet" "data1_subnet" {
  name                 = var.data1_subnet_name
  resource_group_name  = var.virtual_network_resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  depends_on = [azurerm_resource_group_template_deployment.projectvpn]
  address_prefix = "{$var.data1_subnet_ip}"
}

resource "azurerm_subnet" "data2_subnet" {
  name                 = var.data2_subnet_name
  resource_group_name  = var.virtual_network_resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  depends_on = [azurerm_resource_group_template_deployment.projectvpn]
  address_prefix = "{$var.data2_subnet_ip}"
}

resource "azurerm_subnet" "data3_subnet" {
  name                 = var.data3_subnet_name
  resource_group_name  = var.virtual_network_resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  depends_on = [azurerm_resource_group_template_deployment.projectvpn]
  address_prefix = "{$var.data3_subnet_ip}"
}

resource "azurerm_resource_group" "projectvpn" {
  name     = "projectvpn-rg"
  location = var.location
}

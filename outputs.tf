output "mgmtNIC" {
  value = azurerm_resource_group_template_deployment.projectvpn.outputs["mgmtNIC"]
}

output "data1NIC" {
  value = azurerm_resource_group_template_deployment.projectvpn.outputs["data1NIC"]
}

output "data2NIC" {
  value = azurerm_resource_group_template_deployment.projectvpn.outputs["data2NIC"]
}

output "data3NIC" {
  value = azurerm_resource_group_template_deployment.projectvpn.outputs["data3NIC"]
}

output "STORAGE_URI" {
  value = azurerm_resource_group_template_deployment.projectvpn.outputs["STORAGE_URI"]
}

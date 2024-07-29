locals {
  parameters = {
    "vmName" = {
      value = var.vm_name
    },
    "adminUsername" = {
      value = var.admin_username
    },
    "adminPassword" = {
      value = var.admin_password
    },
    "availabilityZone" = {
      value = var.availability_zone
    },
    "vmStorageAccount" = {
      value = var.vm_storage_account
    },
    "virtualNetworkResourceGroup" = {
      value = var.virtual_network_resource_group
    },
    "virtualNetworkName" = {
      value = var.virtual_network_name
    },
    "mgmtSubnetName" = {
      value = var.mgmt_subnet_name
    },
    "mgmtSubnetIP" = {
      value = var.mgmt_subnet_ip
    },
    "data1SubnetName" = {
      value = var.data1_subnet_name
    },
    "data1SubnetIP" = {
      value = var.data1_subnet_ip
    },
    "data2SubnetName" = {
      value = var.data2_subnet_name
    },
    "data2SubnetIP" = {
      value = var.data2_subnet_ip
    },
    "data3SubnetName" = {
      value = var.data3_subnet_name
    },
    "data3SubnetIP" = {
      value = var.data3_subnet_ip
    },
    "vmSize" = {
      value = var.vm_size
    },
    "location" = {
      value = var.location
    },
    "baseStorageURI" = {
      value = var.base_storage_uri
    },
    "vnetName" = {
      value = var.stouts_vnet
  }
}

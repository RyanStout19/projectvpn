terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.106.1"
    }
  }
}
provider "azurerm" {
  features {}
}

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
    }
  }
}

resource "azurerm_resource_group" "projectvpn" {
  name     = "projectvpn-rg"
  location = var.location

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_resource_group_template_deployment" "projectvpn" {
  name                = "projectvpn-rg"
  resource_group_name = azurerm_resource_group.projectvpn.name
  deployment_mode     = "Incremental"

  parameters_content = jsonencode(local.parameters)
  template_content = <<TEMPLATE

{
   "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
   "contentVersion": "1.0.0.0",
   "parameters": {
      "vmName": {
         "type": "string",
         "defaultValue": "asa-vm00",
         "metadata": {
            "description": "Name of the ASA Virtual Machine."
         }
      },
      "adminUsername": {
         "type": "string",
         "defaultValue": "",
         "metadata": {
            "description": "Username for the Virtual Machine. admin, Administrator among other values are disallowed - see Azure docs"
         }
      },
      "adminPassword": {
         "type": "securestring",
         "defaultValue": "",
         "metadata": {
            "description": "Password for the Virtual Machine. Passwords must be 12 to 72 chars and have at least 3 of the following: Lowercase, uppercase, numbers, special chars"
         }
      },
      "availabilityZone": {
          "type": "int",
          "defaultValue": 0,
          "minValue": 0,
          "maxValue": 3,
          "metadata": {
              "description": "Specify the availability zone for deployment. Ensure that selected region supports availability zones and value provided is correct. Set to 0 if you do not want to use Availability Zones"
          }
      },
      "vmStorageAccount": {
         "type": "string",
         "defaultValue": "",
         "metadata": {
            "description": "A storage account name (boot diags require a storage account). Between 3 and 24 characters. Lowercase letters and numbers only"
         }
      },
      "virtualNetworkResourceGroup": {
         "type": "string",
         "defaultValue": "",
         "metadata": {
            "description": "Name of the virtual network's Resource Group"
         }
      },
      "virtualNetworkName": {
         "type": "string",
         "defaultValue": "",
         "metadata": {
            "description": "Name of the virtual network"
         }
      },
      "mgmtSubnetName": {
         "type": "string",
         "defaultValue": "",
         "metadata": {
            "description": "The management interface will attach to this subnet"
         }
      },
      "mgmtSubnetIP": {
         "type": "string",
         "defaultValue": "",
         "metadata": {
            "description": "ASAv IP on the mgmt interface (example: 192.168.0.10)"
         }
      },
      "data1SubnetName": {
         "type": "string",
         "defaultValue": "",
         "metadata": {
            "description": "The ASAv data1 interface will attach to this subnet"
         }
      },
      "data1SubnetIP": {
         "type": "string",
         "defaultValue": "",
         "metadata": {
            "description": "ASAv IP on the data1 interface (example: 192.168.1.10)"
         }
      },
      "data2SubnetName": {
         "type": "string",
         "defaultValue": "",
         "metadata": {
            "description": "The ASAv data2 interface will attach to this subnet"
         }
      },
      "data2SubnetIP": {
         "type": "string",
         "defaultValue": "",
         "metadata": {
            "description": "ASAv IP on the data2 interface (example: 192.168.2.10)"
         }
      },
      "data3SubnetName": {
         "type": "string",
         "defaultValue": "",
         "metadata": {
            "description": "The ASAv data3 interface will attach to this subnet"
         }
      },
      "data3SubnetIP": {
         "type": "string",
         "defaultValue": "",
         "metadata": {
            "description": "ASAv IP on the data3 interface (example: 192.168.3.10)"
         }
      },
      "vmSize": {
         "type": "string",
         "defaultValue": "Standard_D3_v2",
         "allowedValues": [
            "Standard_D3",
            "Standard_D4",
            "Standard_D5",
            "Standard_D3_v2",
            "Standard_D4_v2",
            "Standard_D5_v2",
            "Standard_D8_v3",
            "Standard_D16_v3",
            "Standard_D8s_v3",
            "Standard_D16s_v3",
            "Standard_DS3",
            "Standard_DS4",
            "Standard_DS5",
            "Standard_DS3_v2",
            "Standard_DS4_v2",
            "Standard_DS5_v2",
            "Standard_F4",
            "Standard_F8",
            "Standard_F16",
            "Standard_F4s",
            "Standard_F8s",
            "Standard_F16s",
            "Standard_F8s_v2",
            "Standard_F16s_v2"
         ],
         "metadata": {
            "description": "Size of the ASAv Virtual Machine"
         }
      },
      "location": {
        "type": "string",
        "defaultValue": "[resourceGroup().location]",
        "metadata": {
          "description": "Location for all resources."
        }
      },
      "baseStorageURI": {
         "type": "string",
         "defaultValue": ".blob.core.windows.net",
         "metadata": {
            "description": "Base suffix for Azure storage URIs."
         }
      }
   },
   "variables": {
      "subnet1Ref": "[resourceId(parameters('virtualNetworkResourceGroup'), 'Microsoft.Network/virtualNetworks/subnets/', parameters('virtualNetworkName'), parameters('mgmtSubnetName'))]",
      "subnet2Ref": "[resourceId(parameters('virtualNetworkResourceGroup'), 'Microsoft.Network/virtualNetworks/subnets/', parameters('virtualNetworkName'), parameters('data1SubnetName'))]",
      "subnet3Ref": "[resourceId(parameters('virtualNetworkResourceGroup'), 'Microsoft.Network/virtualNetworks/subnets/', parameters('virtualNetworkName'), parameters('data2SubnetName'))]",
      "subnet4Ref": "[resourceId(parameters('virtualNetworkResourceGroup'), 'Microsoft.Network/virtualNetworks/subnets/', parameters('virtualNetworkName'), parameters('data3SubnetName'))]",
      "vmNic0Name": "[concat(parameters('vmName'),'-nic0')]",
      "vmNic1Name": "[concat(parameters('vmName'),'-nic1')]",
      "vmNic2Name": "[concat(parameters('vmName'),'-nic2')]",
      "vmNic3Name": "[concat(parameters('vmName'),'-nic3')]",
      "mgtNsgName": "[concat(parameters('vmName'),'-SSH-SecurityGroup')]",
      "vmMgmtPublicIPAddressName": "[concat(parameters('vmName'),'nic0-ip')]",
      "vmMgmtPublicIPAddressType": "Static",
      "vmMgmtPublicIPAddressDnsName": "[variables('vmMgmtPublicIPAddressName')]",
      "selectedAvailZone":"[if(equals(parameters('availabilityZone'), 0), json('null'), array(parameters('availabilityZone')))]",
      "pipSku": "Standard"
   },
   "resources": [
      {
         "apiVersion": "2023-06-01",
         "type": "Microsoft.Network/publicIPAddresses",
         "name": "[variables('vmMgmtPublicIPAddressName')]",
         "location": "[parameters('location')]",
         "sku": {
             "name": "[variables('pipSku')]"
         },
         "properties": {
            "publicIPAllocationMethod": "[variables('vmMgmtPublicIpAddressType')]",
            "dnsSettings": {
               "domainNameLabel": "[variables('vmMgmtPublicIPAddressDnsName')]"
            }
         },
         "zones": "[variables('selectedAvailZone')]"
      },
      {
         "apiVersion": "2023-06-01",
         "type": "Microsoft.Network/networkSecurityGroups",
         "name": "[variables('mgtNsgName')]",
         "location": "[parameters('location')]",
         "properties": {
            "securityRules": [
               {
                  "name": "SSH-Rule",
                  "properties": {
                        "description": "Allow SSH",
                        "protocol": "Tcp",
                        "sourcePortRange": "*",
                        "destinationPortRange": "22",
                        "sourceAddressPrefix": "*",
                        "destinationAddressPrefix": "*",
                        "access": "Allow",
                        "priority": 100,
                        "direction": "Inbound"
                  }
               },
               {
                  "name": "UDP-Rule1",
                  "properties": {
                        "description": "Allow UDP",
                        "protocol": "Udp",
                        "sourcePortRange": "*",
                        "destinationPortRange": "500",
                        "sourceAddressPrefix": "*",
                        "destinationAddressPrefix": "*",
                        "access": "Allow",
                        "priority": 101,
                        "direction": "Inbound"
                  }
               },
               {
                  "name": "UDP-Rule2",
                  "properties": {
                        "description": "Allow UDP",
                        "protocol": "Udp",
                        "sourcePortRange": "*",
                        "destinationPortRange": "4500",
                        "sourceAddressPrefix": "*",
                        "destinationAddressPrefix": "*",
                        "access": "Allow",
                        "priority": 102,
                        "direction": "Inbound"
                  }
               }
            ]
         }
      },
      {
         "apiVersion": "2023-06-01",
         "type": "Microsoft.Network/networkInterfaces",
         "name": "[variables('vmNic0Name')]",
         "location": "[parameters('location')]",
         "dependsOn": [
            "[resourceId('Microsoft.Network/networkSecurityGroups',variables('mgtNsgName'))]",
            "[resourceId('Microsoft.Network/publicIPAddresses', variables('vmMgmtPublicIPAddressName'))]"
         ],
         "properties": {
            "ipConfigurations": [
               {
                  "name": "ipconfig1",
                  "properties": {
                     "privateIPAllocationMethod": "Static",
                     "privateIPAddress": "[parameters('mgmtSubnetIP')]",
                     "subnet": {
                        "id": "[variables('subnet1Ref')]"
                     },
                     "publicIPAddress": {
                        "id": "[resourceId('Microsoft.Network/publicIPAddresses/', variables('vmMgmtPublicIPAddressName'))]"
                     }
                  }
               }
            ],
            "networkSecurityGroup": {
               "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('mgtNsgName'))]"
            },
            "enableAcceleratedNetworking": false,
            "enableIPForwarding": true
         }
      },
      {
         "apiVersion": "2023-06-01",
         "type": "Microsoft.Network/networkInterfaces",
         "name": "[variables('vmNic1Name')]",
         "location": "[parameters('location')]",
         "properties": {
            "ipConfigurations": [
               {
                  "name": "ipconfig1",
                  "properties": {
                     "privateIPAllocationMethod": "Static",
                     "privateIPAddress": "[parameters('data1SubnetIP')]",
                     "subnet": {
                        "id": "[variables('subnet2Ref')]"
                     }
                  }
               }
            ],
            "enableAcceleratedNetworking": true,
            "enableIPForwarding": true
         }
      },
      {
         "apiVersion": "2023-06-01",
         "type": "Microsoft.Network/networkInterfaces",
         "name": "[variables('vmNic2Name')]",
         "location": "[parameters('location')]",
         "properties": {
            "ipConfigurations": [
               {
                  "name": "ipconfig1",
                  "properties": {
                     "privateIPAllocationMethod": "Static",
                     "privateIPAddress": "[parameters('data2SubnetIP')]",
                     "subnet": {
                        "id": "[variables('subnet3Ref')]"
                     }
                  }
               }
            ],
            "enableAcceleratedNetworking": true,
            "enableIPForwarding": true
         }
      },
      {
         "apiVersion": "2023-06-01",
         "type": "Microsoft.Network/networkInterfaces",
         "name": "[variables('vmNic3Name')]",
         "location": "[parameters('location')]",
         "properties": {
            "ipConfigurations": [
               {
                  "name": "ipconfig1",
                  "properties": {
                     "privateIPAllocationMethod": "Static",
                     "privateIPAddress": "[parameters('data3SubnetIP')]",
                     "subnet": {
                        "id": "[variables('subnet4Ref')]"
                     }
                  }
               }
            ],
            "enableAcceleratedNetworking": true,
            "enableIPForwarding": true
         }
      },
      {
         "type": "Microsoft.Storage/storageAccounts",
         "name": "[concat(parameters('vmStorageAccount'))]",
         "apiVersion": "2023-04-01",
         "sku": {
            "name": "Standard_LRS"
         },
         "location": "[parameters('location')]",
         "kind": "Storage",
         "properties": {}
      },
      {
         "apiVersion": "2022-03-01",
         "type": "Microsoft.Compute/virtualMachines",
         "name": "[parameters('vmName')]",
         "location": "[parameters('location')]",
     "plan": {
                "name": "asav-azure-byol",
                "product": "cisco-asav",
                "publisher": "cisco"
         },
         "dependsOn": [
            "[resourceId('Microsoft.Storage/storageAccounts', parameters('vmStorageAccount'))]",
            "[resourceId('Microsoft.Network/networkInterfaces',variables('vmNic0Name'))]",
            "[resourceId('Microsoft.Network/networkInterfaces',variables('vmNic1Name'))]",
            "[resourceId('Microsoft.Network/networkInterfaces',variables('vmNic2Name'))]",
            "[resourceId('Microsoft.Network/networkInterfaces',variables('vmNic3Name'))]"
         ],
         "properties": {
            "hardwareProfile": {
               "vmSize": "[parameters('vmSize')]"
            },
            "osProfile": {
               "computername": "[parameters('vmName')]",
               "adminUsername": "[parameters('AdminUsername')]",
               "adminPassword": "[parameters('AdminPassword')]"
            },
            "storageProfile": {
               "imageReference": {
            "publisher": "cisco",
            "sku": "asav-azure-byol",
            "version": "latest",
            "offer": "cisco-asav"       
               },
               "osDisk": {
                  "osType": "Linux",
                  "caching": "ReadWrite",
                  "createOption": "FromImage"
               }
            },
            "networkProfile": {
               "networkInterfaces": [
                  {
                     "properties": {
                        "primary": true
                     },
                     "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('vmNic0Name'))]"
                  },
                  {
                     "properties": {
                        "primary": false
                     },
                     "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('vmNic1Name'))]"
                  },
                  {
                     "properties": {
                        "primary": false
                     },
                     "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('vmNic2Name'))]"
                  },
                  {
                     "properties": {
                        "primary": false
                     },
                     "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('vmNic3Name'))]"
                  }
               ]
            },
            "diagnosticsProfile": {
               "bootDiagnostics": {
                  "enabled": true,
                  "storageUri": "[uri(concat('http://',parameters('vmStorageAccount'),parameters('baseStorageURI')), '')]"
               }
            }
         },
         "zones": "[variables('selectedAvailZone')]"
      }
   ],
   "outputs": {}
}
TEMPLATE
}

output "arm_example_output" {
  value = jsondecode(azurerm_resource_group_template_deployment.projectvpn.output_content).exampleOutput.value
}

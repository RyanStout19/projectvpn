resource "azurerm_resource_group_template_deployment" "projectvpn-asa" {
   name                = "projectvpn-2"
   deployment_mode     = "Incremental"
   resource_group_name = azurerm_resource_group.projectvpn.name
   depends_on = [azurerm_resource_group_template_deployment.projectvpn]
   
   template_content = <<TEMPLATE
{
   "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
   "contentVersion": "1.0.0.0",
   "parameters": {
      "vmNamePrefix": {
         "type": "string",
         "defaultValue": "asa-vm",
         "metadata": {
            "description": "Prefix for the ASA Virtual Machine names."
         }
      },
      "mod_count": {
         "type": "int",
         "defaultValue": "2",
         "metadata": {
            "description": "Number of Virtual Machines to deploy."
         }
      },
      "adminUsername": {
         "type": "string",
         "defaultValue": "${var.admin_username}",
         "metadata": {
            "description": "Username for the Virtual Machine. admin, Administrator among other values are disallowed - see Azure docs"
         }
      },
      "adminPassword": {
         "type": "securestring",
         "defaultValue": "${var.admin_password}",
         "metadata": {
            "description": "Password for the Virtual Machine. Passwords must be 12 to 72 chars and have at least 3 of the following: Lowercase, uppercase, numbers, special chars"
         }
      },
      "availabilityZone": {
         "type": "int",
         "defaultValue": 1,
         "minValue": 0,
         "maxValue": 3,
         "metadata": {
            "description": "Specify the availability zone for deployment. Ensure that selected region supports availability zones and value provided is correct. Set to 0 if you do not want to use Availability Zones"
         }
      },
      "virtualNetworkResourceGroup": {
         "type": "string",
         "defaultValue": "${var.virtual_network_resource_group}",
         "metadata": {
            "description": "Name of the virtual network's Resource Group"
         }
      },
      "virtualNetworkName": {
         "type": "string",
         "defaultValue": "${var.virtual_network_name}",
         "metadata": {
            "description": "Name of the virtual network"
         }
      },
      "mgmtSubnetName": {
         "type": "string",
         "defaultValue": "${var.mgmt_subnet_name}",
         "metadata": {
            "description": "The management interface will attach to this subnet"
         }
      },
      "mgmtSubnetIPPrefix": {
         "type": "string",
         "defaultValue": "${var.mgmt_subnet_ip_prefix}",
         "metadata": {
            "description": "Prefix for the ASAv IPs on the mgmt interface (example: 192.168.0.)"
         }
      },
      "data1SubnetName": {
         "type": "string",
         "defaultValue": "${var.data1_subnet_name}",
         "metadata": {
            "description": "The ASAv data1 interface will attach to this subnet"
         }
      },
      "data1SubnetIPPrefix": {
         "type": "string",
         "defaultValue": "${var.data1_subnet_ip_prefix}",
         "metadata": {
            "description": "Prefix for the ASAv IPs on the data1 interface (example: 192.168.1.)"
         }
      },
      "data2SubnetName": {
         "type": "string",
         "defaultValue": "${var.data2_subnet_name}",
         "metadata": {
            "description": "The ASAv data2 interface will attach to this subnet"
         }
      },
      "data2SubnetIPPrefix": {
         "type": "string",
         "defaultValue": "${var.data2_subnet_ip_prefix}",
         "metadata": {
            "description": "Prefix for the ASAv IPs on the data2 interface (example: 192.168.2.)"
         }
      },
      "data3SubnetName": {
         "type": "string",
         "defaultValue": "${var.data3_subnet_name}",
         "metadata": {
            "description": "The ASAv data3 interface will attach to this subnet"
         }
      },
      "data3SubnetIPPrefix": {
         "type": "string",
         "defaultValue": "${var.data3_subnet_ip_prefix}",
         "metadata": {
            "description": "Prefix for the ASAv IPs on the data3 interface (example: 192.168.3.)"
         }
      },
      "vmSize": {
         "type": "string",
         "defaultValue": "Standard_D3_v2",
         "allowedValues": [
            "Standard_B1s",
            "Standard_B2s",
            "Standard_D3_v2"
         ],
         "metadata": {
            "description": "Size of the virtual machine"
         }
      },
      "location": {
         "type": "string",
         "defaultValue": "North Europe",
         "metadata": {
            "description": "Location (default: resource group location)"
         }
      }
   },
   "variables": {
      "VNET_ID": "[resourceId(parameters('virtualNetworkResourceGroup'),'Microsoft.Network/virtualNetworks',parameters('virtualNetworkName'))]"
   },
   "resources": [
      {
         "type": "Microsoft.Network/networkInterfaces",
         "apiVersion": "2021-02-01",
         "name": "[concat(parameters('vmNamePrefix'), copyIndex(), '-nic-0')]",
         "location": "[parameters('location')]",
         "properties": {
            "ipConfigurations": [
               {
                  "name": "ipconfig1",
                  "properties": {
                     "primary": true,
                     "privateIPAllocationMethod": "Static",
                     "privateIPAddress": "[concat(parameters('mgmtSubnetIPPrefix'), copyIndex(), '.10')]",
                     "subnet": {
                        "id": "[concat(variables('VNET_ID'),'/subnets/',parameters('mgmtSubnetName'))]"
                     }
                  }
               }
            ]
         },
         "copy": {
            "name": "nicCopy",
            "count": "[parameters('mod_count')]"
         }
      },
      {
         "type": "Microsoft.Network/networkInterfaces",
         "apiVersion": "2021-02-01",
         "name": "[concat(parameters('vmNamePrefix'), copyIndex(), '-nic-1')]",
         "location": "[parameters('location')]",
         "properties": {
            "ipConfigurations": [
               {
                  "name": "ipconfig1",
                  "properties": {
                     "primary": false,
                     "privateIPAllocationMethod": "Static",
                     "privateIPAddress": "[concat(parameters('data1SubnetIPPrefix'), copyIndex(), '.10')]",
                     "subnet": {
                        "id": "[concat(variables('VNET_ID'),'/subnets/',parameters('data1SubnetName'))]"
                     }
                  }
               }
            ]
         },
         "copy": {
            "name": "nicCopy",
            "count": "[parameters('mod_count')]"
         }
      },
      {
         "type": "Microsoft.Network/networkInterfaces",
         "apiVersion": "2021-02-01",
         "name": "[concat(parameters('vmNamePrefix'), copyIndex(), '-nic-2')]",
         "location": "[parameters('location')]",
         "properties": {
            "ipConfigurations": [
               {
                  "name": "ipconfig1",
                  "properties": {
                     "primary": false,
                     "privateIPAllocationMethod": "Static",
                     "privateIPAddress": "[concat(parameters('data2SubnetIPPrefix'), copyIndex(), '.10')]",
                     "subnet": {
                        "id": "[concat(variables('VNET_ID'),'/subnets/',parameters('data2SubnetName'))]"
                     }
                  }
               }
            ]
         },
         "copy": {
            "name": "nicCopy",
            "count": "[parameters('mod_count')]"
         }
      },
      {
         "type": "Microsoft.Network/networkInterfaces",
         "apiVersion": "2021-02-01",
         "name": "[concat(parameters('vmNamePrefix'), copyIndex(), '-nic-3')]",
         "location": "[parameters('location')]",
         "properties": {
            "ipConfigurations": [
               {
                  "name": "ipconfig1",
                  "properties": {
                     "primary": false,
                     "privateIPAllocationMethod": "Static",
                     "privateIPAddress": "[concat(parameters('data3SubnetIPPrefix'), copyIndex(), '.10')]",
                     "subnet": {
                        "id": "[concat(variables('VNET_ID'),'/subnets/',parameters('data3SubnetName'))]"
                     }
                  }
               }
            ]
         },
         "copy": {
            "name": "nicCopy",
            "count": "[parameters('mod_count')]"
         }
      },
      {
         "type": "Microsoft.Compute/virtualMachines",
         "apiVersion": "2021-03-01",
         "name": "[concat(parameters('vmNamePrefix'), copyIndex())]",
         "location": "[parameters('location')]",
         "dependsOn": [
            "[resourceId(parameters('virtualNetworkResourceGroup'), 'Microsoft.Network/networkInterfaces', concat(parameters('vmNamePrefix'), copyIndex(), '-nic-0'))]",
            "[resourceId(parameters('virtualNetworkResourceGroup'), 'Microsoft.Network/networkInterfaces', concat(parameters('vmNamePrefix'), copyIndex(), '-nic-1'))]",
            "[resourceId(parameters('virtualNetworkResourceGroup'), 'Microsoft.Network/networkInterfaces', concat(parameters('vmNamePrefix'), copyIndex(), '-nic-2'))]",
            "[resourceId(parameters('virtualNetworkResourceGroup'), 'Microsoft.Network/networkInterfaces', concat(parameters('vmNamePrefix'), copyIndex(), '-nic-3'))]"
          ],
         "plan": {
            "name": "asav-azure-byol",
            "publisher": "cisco",
            "product": "cisco-asav"
         },
         "properties": {
            "hardwareProfile": {
               "vmSize": "[parameters('vmSize')]"
            },
            "storageProfile": {
               "imageReference": {
                  "publisher": "cisco",
                  "offer": "cisco-asav",
                  "sku": "asav-azure-byol",
                  "version": "latest"
               }
            },
            "osProfile": {
               "computerName": "[concat(parameters('vmNamePrefix'), copyIndex())]",
               "adminUsername": "[parameters('adminUsername')]",
               "adminPassword": "[parameters('adminPassword')]"
            },
            "networkProfile": {
               "networkInterfaces": [
                  {
                     "id": "[concat('/subscriptions/', subscription().subscriptionId, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/networkInterfaces/', parameters('vmNamePrefix'), copyIndex(), '-nic-0')]",
                     "properties": {
                        "primary": true
                     }
                  },
                  {
                     "id": "[concat('/subscriptions/', subscription().subscriptionId, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/networkInterfaces/', parameters('vmNamePrefix'), copyIndex(), '-nic-1')]",
                     "properties": {
                        "primary": false
                     }
                  },
                  {
                     "id": "[concat('/subscriptions/', subscription().subscriptionId, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/networkInterfaces/', parameters('vmNamePrefix'), copyIndex(), '-nic-2')]",
                     "properties": {
                        "primary": false
                     }
                  },
                  {
                     "id": "[concat('/subscriptions/', subscription().subscriptionId, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/networkInterfaces/', parameters('vmNamePrefix'), copyIndex(), '-nic-3')]",
                     "properties": {
                        "primary": false
                     }
                  }
               ]
            }
         },
         "zones": [
            "[if(equals(parameters('availabilityZone'), 0), json('null'), parameters('availabilityZone'))]"
         ],
         "copy": {
            "name": "vmCopy",
            "count": "[parameters('mod_count')]"
         }
      }
   ],
   "outputs": {
      "vmNames": {
         "type": "array",
         "value": "[array(range(0, parameters('mod_count')), concat(parameters('vmNamePrefix'), copyIndex()))]"
      }
   }
}
TEMPLATE
}

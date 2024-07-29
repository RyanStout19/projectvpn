resource "azurerm_resource_group_template_deployment" "projectvpn" {
  name                = "projectvpn-rg"
  resource_group_name = projectvpn-2
  deployment_mode     = "Complete"

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
          "defaultValue": 1,
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
            "Standard_DS8_v3",
            "Standard_DS16_v3",
            "Standard_DS8s_v3",
            "Standard_DS16s_v3"
         ],
         "metadata": {
            "description": "Size of the virtual machine"
         }
      },
      "location": {
         "type": "string",
         "defaultValue": "",
         "metadata": {
            "description": "Location (default: resource group location)"
         }
      },
      "baseStorageURI": {
         "type": "string",
         "defaultValue": ".blob.core.windows.net",
         "metadata": {
            "description": "Base URI for all Azure Storage Accounts"
         }
      }
   },
   "variables": {
      "VNET_ID": "[resourceId(parameters('virtualNetworkResourceGroup'),'Microsoft.Network/virtualNetworks',parameters('virtualNetworkName'))]",
      "NIC_ID_0": "[resourceId('Microsoft.Network/networkInterfaces', concat(parameters('vmName'),'-nic-0'))]",
      "NIC_ID_1": "[resourceId('Microsoft.Network/networkInterfaces', concat(parameters('vmName'),'-nic-1'))]",
      "NIC_ID_2": "[resourceId('Microsoft.Network/networkInterfaces', concat(parameters('vmName'),'-nic-2'))]",
      "NIC_ID_3": "[resourceId('Microsoft.Network/networkInterfaces', concat(parameters('vmName'),'-nic-3'))]",
      "STORAGE_URI": "[concat('https://',parameters('vmStorageAccount'),parameters('baseStorageURI'))]"
   },
   "resources": [
      {
         "type": "Microsoft.Network/networkInterfaces",
         "apiVersion": "2021-02-01",
         "name": "[concat(parameters('vmName'),'-nic-0')]",
         "location": "[parameters('location')]",
         "properties": {
            "ipConfigurations": [
               {
                  "name": "ipconfig1",
                  "properties": {
                     "privateIPAllocationMethod": "Static",
                     "privateIPAddress": "[parameters('mgmtSubnetIP')]",
                     "subnet": {
                        "id": "[concat(variables('VNET_ID'),'/subnets/',parameters('mgmtSubnetName'))]"
                     }
                  }
               }
            ]
         }
      },
      {
         "type": "Microsoft.Network/networkInterfaces",
         "apiVersion": "2021-02-01",
         "name": "[concat(parameters('vmName'),'-nic-1')]",
         "location": "[parameters('location')]",
         "properties": {
            "ipConfigurations": [
               {
                  "name": "ipconfig1",
                  "properties": {
                     "privateIPAllocationMethod": "Static",
                     "privateIPAddress": "[parameters('data1SubnetIP')]",
                     "subnet": {
                        "id": "[concat(variables('VNET_ID'),'/subnets/',parameters('data1SubnetName'))]"
                     }
                  }
               }
            ]
         }
      },
      {
         "type": "Microsoft.Network/networkInterfaces",
         "apiVersion": "2021-02-01",
         "name": "[concat(parameters('vmName'),'-nic-2')]",
         "location": "[parameters('location')]",
         "properties": {
            "ipConfigurations": [
               {
                  "name": "ipconfig1",
                  "properties": {
                     "privateIPAllocationMethod": "Static",
                     "privateIPAddress": "[parameters('data2SubnetIP')]",
                     "subnet": {
                        "id": "[concat(variables('VNET_ID'),'/subnets/',parameters('data2SubnetName'))]"
                     }
                  }
               }
            ]
         }
      },
      {
         "type": "Microsoft.Network/networkInterfaces",
         "apiVersion": "2021-02-01",
         "name": "[concat(parameters('vmName'),'-nic-3')]",
         "location": "[parameters('location')]",
         "properties": {
            "ipConfigurations": [
               {
                  "name": "ipconfig1",
                  "properties": {
                     "privateIPAllocationMethod": "Static",
                     "privateIPAddress": "[parameters('data3SubnetIP')]",
                     "subnet": {
                        "id": "[concat(variables('VNET_ID'),'/subnets/',parameters('data3SubnetName'))]"
                     }
                  }
               }
            ]
         }
      },
      {
         "type": "Microsoft.Compute/virtualMachines",
         "apiVersion": "2021-03-01",
         "name": "[parameters('vmName')]",
         "location": "[parameters('location')]",
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
               "computerName": "[parameters('vmName')]",
               "adminUsername": "[parameters('adminUsername')]",
               "adminPassword": "[parameters('adminPassword')]"
            },
            "networkProfile": {
               "networkInterfaces": [
                  {
                     "id": "[variables('NIC_ID_0')]"
                  },
                  {
                     "id": "[variables('NIC_ID_1')]"
                  },
                  {
                     "id": "[variables('NIC_ID_2')]"
                  },
                  {
                     "id": "[variables('NIC_ID_3')]"
                  }
               ]
            },
            "diagnosticsProfile": {
               "bootDiagnostics": {
                  "enabled": "true",
                  "storageUri": "[variables('STORAGE_URI')]"
               }
            }
         },
         "zones": [
            "[if(equals(parameters('availabilityZone'),0),json('null'),parameters('availabilityZone'))]"
         ]
      }
   ],
   "outputs": {
      "mgmtNIC": {
         "type": "string",
         "value": "[variables('NIC_ID_0')]"
      },
      "data1NIC": {
         "type": "string",
         "value": "[variables('NIC_ID_1')]"
      },
      "data2NIC": {
         "type": "string",
         "value": "[variables('NIC_ID_2')]"
      },
      "data3NIC": {
         "type": "string",
         "value": "[variables('NIC_ID_3')]"
      },
      "STORAGE_URI": {
         "type": "string",
         "value": "[variables('STORAGE_URI')]"
      }
   }
}
TEMPLATE
}

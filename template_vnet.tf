resource "azurerm_resource_group_template_deployment" "projectvpn" {
  name                = "projectvpn-vnet"
  deployment_mode     = "Incremental"
  resource_group_name = azurerm_resource_group.projectvpn.name

template_content = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "metadata": {
    "_generator": {
      "name": "bicep",
      "version": "0.6.18.56646",
      "templateHash": "10806234693722113459"
    }
  },
  "parameters": {
    "vnetName": {
      "type": "string",
      "defaultValue": "VNet1",
      "metadata": {
        "description": "VNet name"
      }
    },
    "vnetAddressPrefix": {
      "type": "string",
      "defaultValue": "10.0.0.0/16",
      "metadata": {
        "description": "Address prefix"
      }
    },
    "subnet1Prefix": {
      "type": "string",
      "defaultValue": "10.0.0.0/24",
      "metadata": {
        "description": "Subnet 1 Prefix"
      }
    },
    "subnet1Name": {
      "type": "string",
      "defaultValue": "management",
      "metadata": {
        "description": "Subnet 1 Name"
      }
    },
    "subnet2Prefix": {
      "type": "string",
      "defaultValue": "10.0.1.0/24",
      "metadata": {
        "description": "Subnet 2 Prefix"
      }
    },
    "subnet2Name": {
      "type": "string",
      "defaultValue": "data-subnet1",
      "metadata": {
        "description": "Subnet 2 Name"
      }
	},
	"subnet3Prefix": {
      "type": "string",
      "defaultValue": "10.0.2.0/24",
      "metadata": {
        "description": "Subnet 3 Prefix"
      }
    },
    "subnet3Name": {
      "type": "string",
      "defaultValue": "data-subnet2",
      "metadata": {
        "description": "Subnet 3 Name"
      }
    },
	"subnet4Prefix": {
      "type": "string",
      "defaultValue": "10.0.3.0/24",
      "metadata": {
        "description": "Subnet 3 Prefix"
      }
    },
    "subnet4Name": {
      "type": "string",
      "defaultValue": "data-subnet3",
      "metadata": {
        "description": "Subnet 4 Name"
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]",
      "metadata": {
        "description": "Location for all resources."
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2021-08-01",
      "name": "[parameters('vnetName')]",
      "location": "[parameters('location')]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": [
            "[parameters('vnetAddressPrefix')]"
          ]
        },
        "subnets": [
          {
            "name": "[parameters('subnet1Name')]",
            "properties": {
              "addressPrefix": "[parameters('subnet1Prefix')]"
            }
          },
          {
            "name": "[parameters('subnet2Name')]",
            "properties": {
              "addressPrefix": "[parameters('subnet2Prefix')]"
            }
          },
		  {
            "name": "[parameters('subnet3Name')]",
            "properties": {
              "addressPrefix": "[parameters('subnet3Prefix')]"
            }
		  },
		{
            "name": "[parameters('subnet4Name')]",
            "properties": {
              "addressPrefix": "[parameters('subnet4Prefix')]"
            }
		}
        ]
      }
    }
  ]
}
TEMPLATE
}

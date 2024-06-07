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

resource "azurerm_resource_group" "example" {
  name     = "projectvpn01-rg"
  location = var.location
}

resource "azurerm_resource_group_template_deployment" "example" {
  name                = "projectvpn01-rg"
  resource_group_name = azurerm_resource_group.example.name
  deployment_mode     = "Incremental"

  parameters_content = jsonencode(local.parameters)

  template_content = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": {
      "type": "string",
      "metadata": {
        "description": "Name of the ASA Virtual Machine."
      }
    },
    "adminUsername": {
      "type": "string",
      "metadata": {
        "description": "Username for the Virtual Machine. admin, Administrator among other values are disallowed - see Azure docs"
      }
    },
    "adminPassword": {
      "type": "securestring",
      "metadata": {
        "description": "Password for the Virtual Machine. Passwords must be 12 to 72 chars and have at least 3 of the following: Lowercase, uppercase, numbers, special chars"
      }
    },
    "availabilityZone": {
      "type": "int",
      "metadata": {
        "description": "Specify the availability zone for deployment. Ensure that selected region supports availability zones and value provided is correct. Set to 0 if you do not want to use Availability Zones"
      }
    },
    "vmStorageAccount": {
      "type": "string",
      "metadata": {
        "description": "A storage account name (boot diags require a storage account). Between 3 and 24 characters. Lowercase letters and numbers only"
      }
    },
    "virtualNetworkResourceGroup": {
      "type": "string",
      "metadata": {
        "description": "Name of the virtual network's Resource Group"
      }
    },
    "virtualNetworkName": {
      "type": "string",
      "metadata": {
        "description": "Name of the virtual network"
      }
    },
    "mgmtSubnetName": {
      "type": "string",
      "metadata": {
        "description": "The management interface will attach to this subnet"
      }
    },
    "mgmtSubnetIP": {
      "type": "string",
      "metadata": {
        "description": "ASAv IP on the mgmt interface (example: 10.0.0.10)"
      }
    },
    "data1SubnetName": {
      "type": "string",
      "metadata": {
        "description": "The ASAv data1 interface will attach to this subnet"
      }
    },
    "data1SubnetIP": {
      "type": "string",
      "metadata": {
        "description": "ASAv IP on the data1 interface (example: 10.0.1.10)"
      }
    },
    "data2SubnetName": {
      "type": "string",
      "metadata": {
        "description": "The ASAv data2 interface will attach to this subnet"
      }
    },
    "data2SubnetIP": {
      "type": "string",
      "metadata": {
        "description": "ASAv IP on the data2 interface (example: 10.0.2.10)"
      }
    },
    "data3SubnetName": {
      "type": "string",
      "metadata": {
        "description": "The ASAv data3 interface will attach to this subnet"
      }
    },
    "data3SubnetIP": {
      "type": "string",
      "metadata": {
        "description": "ASAv IP on the data3 interface (example: 10.0.3.10)"
      }
    },
    "vmSize": {
      "type": "string",
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
        "Standard_DS5"
      ],
      "metadata": {
        "description": "The size of the Virtual Machine."
      }
    },
    "baseStorageURI": {
      "type": "string",
      "metadata": {
        "description": "Base URI for the storage account."
      }
    },
    "location": {
      "type": "string",
      "metadata": {
        "description": "The location for the resources."
      }
    }
  },
  "variables": {},
  "resources": [
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2019-07-01",
      "name": "[parameters('vmName')]",
      "location": "[parameters('location')]",
      "properties": {
        "hardwareProfile": {
          "vmSize": "[parameters('vmSize')]"
        },
        "osProfile": {
          "computerName": "[parameters('vmName')]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId(parameters('virtualNetworkResourceGroup'), 'Microsoft.Network/networkInterfaces', 'nic1')]"
            }
          ]
        }
      }
    }
  ],
  "outputs": {
    "exampleOutput": {
      "type": "string",
      "value": "someoutput"
    }
  }
}
TEMPLATE
}

output "arm_example_output" {
  value = jsondecode(azurerm_resource_group_template_deployment.example.output_content).exampleOutput.value
}

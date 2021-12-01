#configurethe azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "tf_jenkins" {
  count    = var.resource_group_count
  name     = "tfjenkins${count.index}"
  location = "Central US"
}

# #create a virtual network
# resource "azurerm_virtual_network" "vnet" {
#   name                = "BatmanInc"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.tf_test.location
#   resource_group_name = azurerm_resource_group.tf_test.name
#   tags = {
#     Environment = "TheBatCave"
#     Team        = "Batman"
#   }
# }

# #create subnet
# resource "azurerm_subnet" "subnet" {
#   name                 = var.azurerm_subnet_name
#   resource_group_name  = azurerm_resource_group.tf_test.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefix       = "10.0.1.0/24"
# }

resource "azurerm_app_service_plan" "svcplan" {
  for_each = azurerm_resource_group.tf_jenkins
  name                = "serviceplantfjenkins"
  location            = "azurerm_resource_group.tf_jenkins${each.key}.location"
  resource_group_name = "azurerm_resource_group.tf_jenkins${each.key}.name"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "appsvc" {
  for_each = azurerm_resource_group.tf_jenkins
  name                = "appservicetfjenkins"
  location            = "azurerm_resource_group.tf_jenkins${each.key}.location"
  resource_group_name = "azurerm_resource_group.tf_jenkins${each.key}.name"
  app_service_plan_id = "azurerm_app_service_plan.svcplan${each.key}.id"


  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
}






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
  tenant_id       = "a0f7e0b9-e7c4-461f-b7cd-b14b2d3cadc4"
  subscription_id = "d3a83b07-1138-454e-8bbe-071a1b79a51d"
  client_id       = "fb611b70-bde0-408f-ba9a-45ad16cf7b9c"
  client_secret   = "pT-TM.VKt9FAHhpsD732lp3Vk4Jos.mRdd"
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "tf_jenkins" {
  name     = "tfjenkins"
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
  name                = "serviceplantfjenkins"
  location            = azurerm_resource_group.tf_jenkins.location
  resource_group_name = azurerm_resource_group.tf_jenkins.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "appsvc" {
  name                = "appservicetfjenkins"
  location            = azurerm_resource_group.tf_jenkins.location
  resource_group_name = azurerm_resource_group.tf_jenkins.name
  app_service_plan_id = azurerm_app_service_plan.svcplan.id


  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
}





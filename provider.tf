terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.34.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.5.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azapi" {
}

provider "random" {
}
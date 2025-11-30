terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.21.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=3.0.0"
    }
    # azuredevops = {
    #   source = "microsoft/azuredevops"
    # }
    time = {
      source  = "hashicorp/time"
      version = ">=0.10.0"
    }
  }
}

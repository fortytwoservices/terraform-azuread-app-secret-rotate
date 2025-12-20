terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

resource "random_pet" "rg_name" {
  prefix = "rg"
}

resource "azurerm_resource_group" "example" {
  name     = random_pet.rg_name.id
  location = "West Europe"
}

data "azurerm_client_config" "current" {}

resource "random_string" "kv_name" {
  length  = 24
  special = false
  upper   = false
}

#
resource "azurerm_key_vault" "example" {
  name                       = random_string.kv_name.result
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
  rbac_authorization_enabled = true

  network_acls {
    default_action = "Deny"
    bypass         = "None"
  }

  sku_name = "standard"
}

resource "azuread_application" "example" {
  display_name = "example-app-advanced"
}

module "advanced_rotation" {
  source = "../../"

  client_id = azuread_application.example.client_id

  # Advanced configuration
  rotation_days = 30
  rotation_type = "overlap"
  destination   = "keyvault"
  key_vault_id  = azurerm_key_vault.example.id

  # Custom secret naming
  secret_name_prefix = "custom-app-prefix"

  # Expiration settings
  key_vault_secret_expiration_date_enabled  = true
  override_key_vault_secret_expiration_date = 45 # Expires 15 days after rotation (overlap)
}

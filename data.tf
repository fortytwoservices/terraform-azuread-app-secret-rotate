data "azuread_client_config" "current" {}

data "azurerm_client_config" "current" {}

# Get app registration as data resource
data "azuread_application" "app" {
  client_id = var.client_id
}

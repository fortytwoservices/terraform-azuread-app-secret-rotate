mock_provider "azuread" {}
mock_provider "azurerm" {}
mock_provider "random" {}
mock_provider "time" {}

run "test_advanced_example_with_overlap_rotation" {
  command = apply
  module {
    source = "./examples/advanced"
  }

  override_resource {
    target = azuread_application.example
    values = {
      id        = "/applications/00000000-0000-0000-0000-000000000000"
      client_id = "2e382b8b-3fe7-413b-a8ac-4c256b7a54cb"
    }
  }

  override_resource {
    target = azurerm_key_vault.example
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv"
    }
  }

  override_data {
    target = module.advanced_rotation.data.azuread_application.app
    values = {
      id        = "/applications/00000000-0000-0000-0000-000000000000"
      client_id = "2e382b8b-3fe7-413b-a8ac-4c256b7a54cb"
    }
  }

  override_data {
    target = data.azurerm_client_config.current
    values = {
      tenant_id       = "00000000-0000-0000-0000-000000000000"
      object_id       = "00000000-0000-0000-0000-000000000000"
      client_id       = "00000000-0000-0000-0000-000000000000"
      subscription_id = "00000000-0000-0000-0000-000000000000"
    }
  }

  override_data {
    target = module.advanced_rotation.data.azurerm_client_config.current
    values = {
      tenant_id       = "00000000-0000-0000-0000-000000000000"
      object_id       = "00000000-0000-0000-0000-000000000000"
      client_id       = "00000000-0000-0000-0000-000000000000"
      subscription_id = "00000000-0000-0000-0000-000000000000"
    }
  }

  override_data {
    target = module.advanced_rotation.data.azuread_client_config.current
    values = {
      tenant_id = "00000000-0000-0000-0000-000000000000"
      object_id = "00000000-0000-0000-0000-000000000000"
      client_id = "00000000-0000-0000-0000-000000000000"
    }
  }

  assert {
    condition     = azuread_application.example.client_id == "2e382b8b-3fe7-413b-a8ac-4c256b7a54cb"
    error_message = "Application Client ID should be correct"
  }

  assert {
    condition     = module.advanced_rotation.key == "key1"
    error_message = "Active rotation key should be key1"
  }
}

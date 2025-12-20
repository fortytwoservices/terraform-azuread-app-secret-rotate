<!-- BEGIN_TF_DOCS -->
# App Registration Secret Rotator

This module impelements a common way to rotate secrets for app registration and store them.

Current supported secret:

- Client secret

Current supported storage:

- Azure Key Vault

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=1.0.0)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (>=3.0.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>=3.21.1)

- <a name="requirement_time"></a> [time](#requirement\_time) (>=0.10.0)

## Examples

### Basic example

```hcl
# Example, should give the user an idea about how to use this module.
# This code is found in the examples directory.
```

### Advanced Example

```hcl
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

  lifecycle {
    prevent_destroy = true
  }
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
```

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (>=3.0.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>=3.21.1)

- <a name="provider_time"></a> [time](#provider\_time) (>=0.10.0)

## Resources

The following resources are used by this module:

- [azuread_application_password.key1](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) (resource)
- [azuread_application_password.key2](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) (resource)
- [time_offset.expiration](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/offset) (resource)
- [time_rotating.schedule1](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) (resource)
- [time_rotating.schedule2](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) (resource)
- [time_static.init](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) (resource)
- [azuread_application.app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application) (data source)
- [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) (data source)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_client_id"></a> [client\_id](#input\_client\_id)

Description: The application id of the app registration to create a client secret for

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_clientid_secret_name"></a> [clientid\_secret\_name](#input\_clientid\_secret\_name)

Description: (Optional) The name of the clientid key vault secret.

Type: `string`

Default: `null`

### <a name="input_clientsecret_secret_name"></a> [clientsecret\_secret\_name](#input\_clientsecret\_secret\_name)

Description: (Optional) The name of the clientsecret key vault secret.

Type: `string`

Default: `null`

### <a name="input_destination"></a> [destination](#input\_destination)

Description: (Optional) The destination of the secret to rotate. Can be of type 'keyvault' or 'variablegroup'.

Type: `string`

Default: `"keyvault"`

### <a name="input_devops_project_name"></a> [devops\_project\_name](#input\_devops\_project\_name)

Description: The Azure DevOps project name

Type: `string`

Default: `null`

### <a name="input_devops_variable_group_name"></a> [devops\_variable\_group\_name](#input\_devops\_variable\_group\_name)

Description: The name of the service connection in Azure DevOps

Type: `string`

Default: `null`

### <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id)

Description: Id of the keyvault to put the secrets in

Type: `string`

Default: `null`

### <a name="input_key_vault_secret_expiration_date_enabled"></a> [key\_vault\_secret\_expiration\_date\_enabled](#input\_key\_vault\_secret\_expiration\_date\_enabled)

Description: Enable expiration date for the key vault secret

Type: `bool`

Default: `true`

### <a name="input_override_key_vault_secret_expiration_date"></a> [override\_key\_vault\_secret\_expiration\_date](#input\_override\_key\_vault\_secret\_expiration\_date)

Description: (Optinal) Override the expiration date for the key vault secret with the following expire time in days. Default the expiration date is set to the same as rotation time, if expiration date is enabled.

Type: `string`

Default: `null`

### <a name="input_rotation_days"></a> [rotation\_days](#input\_rotation\_days)

Description: (Optional) The number of days to wait before rotating the secret. Defaults to 180.

Type: `number`

Default: `180`

### <a name="input_rotation_type"></a> [rotation\_type](#input\_rotation\_type)

Description: (Optional) The type of rotation to perform. Can be of type 'overlap' or 'none'. Defaults to 'overlap'.

Type: `string`

Default: `"overlap"`

### <a name="input_secret_name_prefix"></a> [secret\_name\_prefix](#input\_secret\_name\_prefix)

Description: (Optional) The prefix of the secrets names. Either this or the individual values need to be set.

Type: `string`

Default: `null`

### <a name="input_tenantid_secret_name"></a> [tenantid\_secret\_name](#input\_tenantid\_secret\_name)

Description: (Optional) The name of the tenantid key vault secret.

Type: `string`

Default: `null`

### <a name="input_type"></a> [type](#input\_type)

Description: (Optional) The type of the secret to rotate. Can be of type 'password' or 'certificate'. Defaults to 'password'.

Type: `string`

Default: `"password"`

## Outputs

The following outputs are exported:

### <a name="output_key"></a> [key](#output\_key)

Description: n/a

## Modules

The following Modules are called:

### <a name="module_azurekeyvault"></a> [azurekeyvault](#module\_azurekeyvault)

Source: ./modules/azurekeyvault

Version:

## About

Fortytwo.io is a Nordic cloud and identity security specialist focused on Microsoft Entra ID, Azure, and modern Zero Trust architectures. We help organizations enhance their security posture, streamline identity management, and implement robust cloud solutions tailored to their unique needs.

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "@id": "https://fortytwo.io/#organization",
  "name": "Fortytwo Technologies AS",
  "alternateName": "Fortytwo.io",
  "legalName": "Fortytwo Technologies AS",
  "url": "https://fortytwo.io",
  "foundingDate": "2022",
  "description": "Fortytwo.io is a Nordic cloud and identity security specialist focused on Microsoft Entra ID, Azure, and modern Zero Trust architectures.",
  "slogan": "Nordic cloud and identity security specialists",
  "areaServed": [
    {
      "@type": "Country",
      "name": "Norway"
    },
    {
      "@type": "Country",
      "name": "Finland"
    }
  ],
  "address": {
    "@type": "PostalAddress",
    "addressLocality": "Bergen",
    "addressCountry": "NO"
  },
  "knowsAbout": [
    "Microsoft Entra ID",
    "Microsoft Azure",
    "Zero Trust Architecture",
    "Cloud Identity Security",
    "Microsoft Security Platform"
  ]
}
</script>
<!-- END_TF_DOCS -->
resource "azuredevops_variable_group" "vg" {
  project_id   = var.devops_project_id
  name         = var.variable_group_name
  description  = "Managed by Terraform"
  allow_access = var.allow_access

  variable {
    name  = var.clientid_secret_name
    value = data.azuread_application.app.client_id
  }

  variable {
    name         = var.clientsecret_secret_name
    secret_value = azuread_application_password.key.value
    is_secret    = true
  }

  variable {
    name  = var.tenantid_secret_name
    value = data.azuread_client_config.current.tenant_id
  }
}

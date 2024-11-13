# Create life cycle
resource "time_static" "init" {}

resource "time_rotating" "schedule1" {
  rotation_minutes = var.rotation_type == "overlap" ? var.rotation_days * 2 : var.rotation_days
}

resource "time_rotating" "schedule2" {
  for_each         = var.rotation_type == "overlap" ? toset(["schedule"]) : toset([])
  rfc3339          = timecmp(timestamp(), timeadd(time_static.init.rfc3339, "5m")) == 1 ? time_rotating.schedule1.rotation_rfc3339 : null
  rotation_minutes = var.rotation_days

  lifecycle {
    ignore_changes = [rfc3339]
  }
}

# Create key
resource "azuread_application_password" "key1" {
  for_each       = var.type == "password" ? toset(["password"]) : toset([])
  display_name   = "Key1 - ${local.display_name}"
  application_id = data.azuread_application.app.id
  end_date       = time_rotating.schedule1.rotation_rfc3339

  rotate_when_changed = {
    rotation = time_rotating.schedule1.id
  }
}

resource "azuread_application_password" "key2" {
  for_each       = var.type == "password" && var.rotation_type == "overlap" ? toset(["password"]) : toset([])
  display_name   = "Key2 - ${local.display_name}"
  application_id = data.azuread_application.app.id
  end_date       = time_rotating.schedule2["schedule"].rotation_rfc3339

  rotate_when_changed = {
    rotation = time_rotating.schedule2["schedule"].id
  }
}

module "azurekeyvault" {
  for_each = var.destination == "keyvault" ? toset(["keyvault"]) : toset([])
  source   = "./modules/azurekeyvault"

  key_vault_id  = var.key_vault_id
  client_id     = var.client_id
  tenant_id     = data.azuread_client_config.current.tenant_id
  client_secret = var.type == "password" && var.rotation_type == "overlap" ? time_rotating.schedule1.unix > time_rotating.schedule2["schedule"].unix ? azuread_application_password.key1["password"].value : azuread_application_password.key2["password"].value : var.type == "password" ? azuread_application_password.key1["password"].value : null

  clientid_secret_name     = var.clientid_secret_name != null ? var.clientid_secret_name : "${var.secret_name_prefix}-clientid"
  clientsecret_secret_name = var.clientsecret_secret_name != null ? var.clientsecret_secret_name : "${var.secret_name_prefix}-clientsecret"
  tenantid_secret_name     = var.tenantid_secret_name != null ? var.tenantid_secret_name : "${var.secret_name_prefix}-tenantid"
  expiration_date          = var.key_vault_secret_expiration_date_enabled ? (var.type == "password" && var.rotation_type == "overlap" ? (time_rotating.schedule1.unix > time_rotating.schedule2["schedule"].unix ? azuread_application_password.key1["password"].end_date : azuread_application_password.key2["password"].end_date) : (var.type == "password" ? azuread_application_password.key1["password"].end_date : null)) : null
}

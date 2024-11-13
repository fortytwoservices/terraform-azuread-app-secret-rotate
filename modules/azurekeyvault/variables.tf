variable "client_id" {
  type        = string
  description = "The application id of the app registration."
}

variable "tenant_id" {
  type        = string
  description = "The tensnt id of the app registration."
}

variable "client_secret" {
  type        = string
  description = "The application scret of the app registration."
  sensitive   = true
}

variable "expiration_date" {
  type        = string
  description = "(Optional) The expiration date of the secret."
  default     = null
}

variable "key_vault_id" {
  type        = string
  description = "Id of the keyvault to put the secrets in."
}

variable "clientid_secret_name" {
  type        = string
  description = "The name of the clientid key vault secret."
}

variable "clientsecret_secret_name" {
  type        = string
  description = "The name of the clientsecret key vault secret."
}

variable "tenantid_secret_name" {
  type        = string
  description = "The name of the tenantid key vault secret."
}

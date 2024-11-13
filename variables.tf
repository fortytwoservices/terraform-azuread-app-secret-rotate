variable "type" {
  description = "(Optional) The type of the secret to rotate. Can be of type 'password' or 'certificate'. Defaults to 'password'."
  type        = string
  default     = "password"
}

variable "rotation_type" {
  description = "(Optional) The type of rotation to perform. Can be of type 'overlap' or 'none'. Defaults to 'overlap'."
  type        = string
  default     = "overlap"
}

variable "destination" {
  description = "(Optional) The destination of the secret to rotate. Can be of type 'keyvault' or 'variablegroup'."
  type        = string
  default     = "keyvault"
}

variable "client_id" {
  type        = string
  description = "The application id of the app registration to create a client secret for"
}

variable "rotation_days" {
  type        = number
  description = "(Optional) The number of days to wait before rotating the secret. Defaults to 180."
  default     = 10
}

variable "secret_name_prefix" {
  type        = string
  description = "(Optional) The prefix of the secrets names. Either this or the individual values need to be set."
  default     = null
}

variable "clientid_secret_name" {
  type        = string
  description = "(Optional) The name of the clientid key vault secret."
  default     = null
}

variable "clientsecret_secret_name" {
  type        = string
  description = "(Optional) The name of the clientsecret key vault secret."
  default     = null
}

variable "tenantid_secret_name" {
  type        = string
  description = "(Optional) The name of the tenantid key vault secret."
  default     = null
}

# Key Vault specific variables
variable "key_vault_id" {
  type        = string
  description = "Id of the keyvault to put the secrets in"
  default     = null
}

variable "key_vault_secret_expiration_date_enabled" {
  type        = bool
  description = "Enable expiration date for the key vault secret"
  default     = true
}

# Azure DevOps Variable Group specific variables
variable "devops_project_name" {
  type        = string
  description = "The Azure DevOps project name"
  default     = null
}

variable "devops_project_id" {
  type        = string
  description = "The Azure DevOps project id, output from the azuredevops_project resource."
  default     = null
}

variable "devops_variable_group_name" {
  type        = string
  description = "The name of the service connection in Azure DevOps"
  default     = null
}

# For type certificate spesific variables
variable "certificate_secret_name" {
  type        = string
  description = "(Optional) The name of the clientcertificate secret"
  default     = null
}

variable "certificate_password_secret_name" {
  type        = string
  description = "(Optional) The name of the clientcertificate secret"
  default     = null
}

variable "certificate_common_name_fqdn" {
  type        = string
  description = "The common name of the certificate"
  default     = null
}

# For type password spesific variables
